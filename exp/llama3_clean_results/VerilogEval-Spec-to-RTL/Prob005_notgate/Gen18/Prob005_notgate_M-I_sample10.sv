// Define the TopModule with a clear description for readability.
module TopModule(
    input  logic in,  // Declare input as logic type for clarity
    output logic out  // Declare output as logic type for clarity
);
    // Implement a NOT gate using a simple assignment for optimal area and power efficiency.
    // This approach is already very efficient and meets the required functional specifications.
    assign out = ~in;  // Directly invert the input signal
endmodule