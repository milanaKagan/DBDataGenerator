
const config = require('config')
const fs = require("fs")
const Pool = require('pg').Pool
const axios = require('axios')

// 1 -- read from config
// config
const db_conn = config.get('db')
const scale = config.get('scale')

// connect to db
const pool = new Pool({
    user: db_conn.user,
    host: db_conn.host,
    database: db_conn.database,
    password: db_conn.password,
    port: db_conn.port,
})

const sleep = (delay) => new Promise((resolve) => setTimeout(resolve, delay))
const randomDate = () => {
    return `2021-${Math.floor(Math.random() * 12) + 1}-${Math.floor(Math.random() * 28) + 1}T00:00:00.000+08:00`;

}
console.log(randomDate(new Date(2020, 0, 1), new Date()));
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

const deleteResetDb = async () => {
    console.log("Db reset and delete tables")

    pool.query('call sp_delete_and_reset_all()', (err) => {
        if (err)
            console.log(`Error during delete and reset all tables: ${err}`)
        console.log(`Db ${db_conn.database} was cleared`)
    });

}

const insertCountries = async () => {
    await sleep(5000);
    console.log("Insert Countries")
    let string_from_file = fs.readFileSync('data\\countries.json', { encoding: 'utf8', flag: 'r' });
    let data = JSON.parse(string_from_file)

    for (let i = 0; i < data.length; i++) {
        pool.query(`select * from sp_insert_countries('${data[i].name}')`, (err) => {
            if (err)
                console.log(`Error during country ${data[i].name} insert: ${err}`)
        });
    }
}

const insertUsersAndCustomers = async () => {
    await sleep(6000);
    console.log("Insert Users and Customers")
    try {
        string_from_file = fs.readFileSync('data\\creditCards.json', { encoding: 'utf8', flag: 'r' });
        let data = JSON.parse(string_from_file)
        const response = await axios.get(`https://randomuser.me/api?results=${scale.customers}`)
        for (let i = 0; i < scale.customers; i++) {
            await sleep(1000);
            pool.query(`select * from sp_insert_user('${response.data.results[i].name.first + makeid(3)}',
             '${response.data.results[i].name.first}_password','${response.data.results[i].email}')`, (err, res) => {
                if (err)
                    console.log(`Error during user ${i} insert: ${err}`)
            });

            address = response.data.results[i].location.country + ', ' +
                response.data.results[i].location.city + ', ' + response.data.results[i].location.street.name +
                ' ' + response.data.results[i].location.street.number;

            await sleep(1000);
            pool.query(`select * from sp_insert_customer('${response.data.results[i].name.first}','${response.data.results[i].name.last}',
            '${address}', '${response.data.results[i].phone}','${data[i].CreditCard.CardNumber}',${i + 1})`, (err, res) => {
                if (err)
                    console.log(`Error during customer ${i} insert: ${err}`)
            });
        }
    }
    catch (err) {

        console.log("Error during random user get: ", err);
    }
}

const insertAirlines = async () => {
    await sleep(47000);
    console.log("Insert Airlines")
    string_from_file = fs.readFileSync('data\\airlines.json', { encoding: 'utf8', flag: 'r' });
    let data = JSON.parse(string_from_file)
    for (let i = 0; i < scale.airlines; i++) {
        pool.query(`select * from sp_insert_airlines('${data[i].name}',${Math.floor(Math.random() * 243) + 1}, 
        ${i + 1})`, (err, res) => {
            if (err)
                console.log(`Error during airline ${i} insert: ${err}`)
        });
    }
}

const insertFlights = async () => {
    await sleep(57000);
    console.log("Insert Flghts")
    for (let i = 0; i < scale.airlines; i++) {
        for (let j = 0; j < (Math.floor(Math.random() * scale.flights_per_airline) + 1); j++) {
            pool.query(`select * from sp_insert_flights('${i + 1}','${Math.floor(Math.random() * 243) + 1}',
            '${Math.floor(Math.random() * 243) + 1}',
            '${randomDate()}',
            '${randomDate()}',
            '${Math.floor(Math.random() * 250)}')`, (err, res) => {
                if (err)
                    console.log(`Error during flight ${i} insert: ${err}`);
            });
        }
    }

}
const insertTickets = async () => {
    await sleep(67000);
    console.log("Insert Tickets")
    for (let i = 0; i < scale.customers; i++) {
        pool.query(`select * from sp_insert_tickets('${i + 1}','${i + 1}')`, (err, res) => {
            if (err)
                console.log(`Error during ticket ${i} insert: ${err}`)
        });
    }
}
deleteResetDb();
insertCountries();
insertUsersAndCustomers();
insertAirlines();
insertFlights();
insertTickets();