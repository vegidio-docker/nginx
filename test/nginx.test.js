const axios = require('axios');

beforeAll(() => {
    expect.assertions(3);
});

describe('Test Nginx', () =>
{
    test('Check HTTP response', () =>
    {
        return axios.get('http://localhost')
            .then((res) => {
                expect(res.status).toBe(200);
                expect(res.headers).toHaveProperty('content-type', 'text/html');
                expect(res.data).toEqual(expect.stringContaining('the nginx web server is successfully installed'));
            });
    });
});
