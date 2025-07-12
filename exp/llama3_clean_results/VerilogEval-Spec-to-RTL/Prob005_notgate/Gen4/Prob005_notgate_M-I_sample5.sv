// Improved version with comments for clarity and understanding
module TopModule(
    input  logic in,  // Define input as logic type for clarity
    output logic out  // Define output as logic type for clarity
);

// Direct assignment is the most efficient way to implement a NOT gate in Verilog
assign out = ~in;  // Use the logical NOT operator to invert the input signal

endmodule