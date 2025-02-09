// index.js
exports.handler = async (event) => {

    const motds = [
        "Hello! This is your Message of the Day: Stay positive and keep learning!",
        "Hi there! Remember, every day is a new opportunity to grow.",
        "Greetings! Don't forget to take a moment to appreciate the little things.",
        "Welcome! Believe in yourself and all that you are capable of.",
        "Hey! Today is a great day to try something new and exciting!"
    ];

    let body = JSON.parse(event.body);
    const randomIndex = Math.floor(Math.random() * motds.length);
    const motd = motds[randomIndex];

    const response = {
        statusCode: 200,
        body: JSON.stringify({ message: motd }),
    };

    return response;
};
