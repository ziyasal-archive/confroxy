import micro from 'micro';
import sleep from 'then-sleep';

export default async function (req, res) {
    await sleep(500);
    res.writeHead(200);
    res.end('woot');
};