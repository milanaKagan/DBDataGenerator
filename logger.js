const { createLogger, format, transports } = require('winston');
const { combine, timestamp, prettyPrint } = format;
 
const logger = createLogger({
  format: combine(
    timestamp(),
    prettyPrint()
  ),
  transports: [new transports.Console(),
    new transports.File({
        filename: 'DBGenerator.log'})
    ]
})

module.exports = logger;