
const { createLogger, format, transports } = require('winston');
const { combine, timestamp, label, prettyPrint } = format;
const bcrypt = require('bcrypt');
const roles = ['admin','airline','customer']
const config = require('config')
const fs = require("fs")
const Pool = require('pg').Pool
const axios = require('axios')
const logger_repo = require('./logger')
// 1 -- read from config
// config
const db_conn = config.get('db')
const scale = config.get('scale')
let countriesCount = 0;
let usersCount = 0;
let customersCount = 0;
let airlinesCount = 0;
let flightsCount = 0;
let ticketsCount = 0;
// connect to db
const pool = new Pool({
    user: db_conn.user,
    host: db_conn.host,
    database: db_conn.database,
    password: db_conn.password,
    port: db_conn.port,
});
const randomDate = () => {
    return `2021-${Math.floor(Math.random() * 12) + 1}-${Math.floor(Math.random() * 28) + 1}T00:00:00.000+08:00`;

}
const makeid = (length) => {
    var result = '';
    var characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    var charactersLength = characters.length;
    for (var i = 0; i < length; i++) {
        result += characters.charAt(Math.floor(Math.random() *
            charactersLength));
    }
    return result;
}
const deleteResetDb = async (client) => {
    await client.query('call sp_delete_and_reset_all()', (err) => {
        if (err) {
            logger_repo.log({
                level: 'error',
                message: `Error during delete and reset all tables: ${err}`
            });
        }
        else {
            logger_repo.log({
                level: 'info',
                message: `Db ${db_conn.database} was cleared`
            });

        }
    });

}
const insertCountries = async (client) => {
    let string_from_file = fs.readFileSync('data\\countries.json', { encoding: 'utf8', flag: 'r' });
    let data = JSON.parse(string_from_file)
    for (let i = 0; i < data.length; i++) {
        await client.query(`select * from sp_insert_countries('${data[i].name}')`, (err) => {
            if (err)
                logger_repo.log({
                    level: 'error',
                    message: `Error during country ${data[i].name} insert: ${err}`
                });
            else
                countriesCount++;
        });
    }

}
const insertUsersAndCustomers = async (client) => {
    try {
        var salt = await bcrypt.genSalt();
        var password = bcrypt.hash('123456', salt);
        string_from_file = fs.readFileSync('data\\creditCards.json', { encoding: 'utf8', flag: 'r' });
        let data = JSON.parse(string_from_file)
        const response = await axios.get(`https://randomuser.me/api?results=${scale.customers}`)
        for (let i = 0; i < scale.customers; i++) {
            await client.query(`select * from sp_insert_user('${response.data.results[i].name.first + makeid(3)}',
             '${password}','${response.data.results[i].email}',
             '${roles[Math.floor(Math.random() * 3)]}')`, (err, res) => {
                if (err)
                    logger_repo.log({
                        level: 'error',
                        message: `Error during user ${i} insert: ${err}`
                    });
                else
                    usersCount++;
            });

            address = response.data.results[i].location.country + ', ' +
                response.data.results[i].location.city + ', ' + response.data.results[i].location.street.name +
                ' ' + response.data.results[i].location.street.number;


            await client.query(`select * from sp_insert_customer('${response.data.results[i].name.first}','${response.data.results[i].name.last}',
            '${address}', '${response.data.results[i].phone}','${data[i].CreditCard.CardNumber}',${i + 1})`, (err, res) => {
                if (err)
                    logger_repo.log({
                        level: 'error',
                        message: `Error during customer ${i} insert: ${err}`
                    });
                else
                    customersCount++;
            });
        }
    }
    catch (err) {
        logger_repo.log({
            level: 'error',
            message: `Error during random user axios get: ${err}`
        });

    }
}
const insertAirlines = async (client) => {
    let string_from_file = fs.readFileSync('data\\airlines.json', { encoding: 'utf8', flag: 'r' });
    let data = JSON.parse(string_from_file)
    for (let i = 0; i < scale.airlines; i++) {
        await client.query(`select * from sp_insert_airlines('${data[i].name}',${Math.floor(Math.random() * 243) + 1}, 
        ${i + 1})`, (err, res) => {
            if (err)
                logger_repo.log({
                    level: 'error',
                    message: `Error during airline ${i} insert: ${err}`
                });
            else
                airlinesCount++;

        });
    }
}
const insertFlights = async (client) => {
    for (let i = 0; i < scale.airlines; i++) {
        for (let j = 0; j < (Math.floor(Math.random() * scale.flights_per_airline) + 1); j++) {
            await client.query(`select * from sp_insert_flights('${i + 1}','${Math.floor(Math.random() * 243) + 1}',
            '${Math.floor(Math.random() * 243) + 1}',
            '${randomDate()}',
            '${randomDate()}',
            '${Math.floor(Math.random() * 250)}')`, (err, res) => {
                if (err)
                    logger_repo.log({
                        level: 'error',
                        message: `Error during flight ${i} insert: ${err}`
                    });
                else
                    flightsCount++;
            });
        }
    }

}
const insertTickets = async (client) => {

    for (let i = 0; i < scale.customers; i++) {
        await client.query(`select * from sp_insert_tickets('${i + 1}','${i + 1}')`, (err, res) => {
            if (err)
                logger_repo.log({
                    level: 'error',
                    message: `Error during ticket ${i} insert: ${err}`
                });
            else
                ticketsCount++;
        });
    }
}
(async () => {
    const client = await pool.connect()
    try {
        await client.query('BEGIN')

        await deleteResetDb(client);
        await insertCountries(client);
        await insertUsersAndCustomers(client);
        await insertAirlines(client);
        await insertFlights(client);
        await insertTickets(client);

        await client.query('COMMIT')
    } catch (e) {
        await client.query('ROLLBACK')
        throw e
    } finally {
        client.release()
        logger_repo.log({
            level: 'info',
            message: `${countriesCount} countries inserted count`
        });
        logger_repo.log({
            level: 'info',
            message: `${usersCount} users inserted count`
        });
        logger_repo.log({
            level: 'info',
            message: `${customersCount} customers inserted count`
        });
        logger_repo.log({
            level: 'info',
            message: `${airlinesCount} airlines inserted count`
        });
        logger_repo.log({
            level: 'info',
            message: `${flightsCount} flights inserted count`
        });
        logger_repo.log({
            level: 'info',
            message: `${ticketsCount} tickets inserted count`
        });
    }
})().catch(e => console.error(e.stack))


