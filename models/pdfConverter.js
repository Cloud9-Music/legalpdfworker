'use strict';
const pdf = require('html-pdf');
const Promise = require('bluebird');
const uuid = require('uuid');
const fileSystem = require('fs');
const options = {
    'border': {
        'top': '1cm',
        'right': '1cm',
        'bottom': '1cm',
        'left': '1cm'
    }
};

const convertHTML2PDF = (htmlPage) => {
    return new Promise((resolve, reject) => {
        pdf.create(htmlPage, options).toFile('./tmp/' + uuid.v4() + '.pdf', (error, res) => {
            if (error) {
                reject({
                    error: error
                });
            } else {
                resolve(res);
            }
        });
    });
}

exports.convert = (data, documentPath, res) => {
    convertHTML2PDF(data).then((output) => {
            res.writeHead(200, {
                'Content-Type': 'application/pdf',
                'Access-Control-Allow-Origin': '*',
                'Content-Disposition': 'attachment; filename="output.pdf"'
            });
            let readStream = fileSystem.createReadStream(output.filename);
            readStream.pipe(res);
            //deleting the file once everything has been sent
            readStream.on('close', function() {
                fileSystem.unlink(output.filename);
                if (documentPath != '')
                    fileSystem.unlink(documentPath);
            });

        },
        (error) => {
            res.status(415).end('Unable to convert the supplied document');
        });
}
