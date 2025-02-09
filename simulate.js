const { handler } = require('./index');

// Simulate AWS Lambda event
(async () => {
    const event = {}; // Add any event properties if needed
    const result = await handler(event);
    console.log("Lambda function response:", result);
})();
