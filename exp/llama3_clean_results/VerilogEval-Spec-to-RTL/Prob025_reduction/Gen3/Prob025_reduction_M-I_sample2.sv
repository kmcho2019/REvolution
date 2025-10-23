// Improved version focusing on clarity and adherence to Verilog best practices
module TopModule(
    input  [7:0] in,  // 8-bit input
    output parity     // 1-bit parity output
);

// Calculate parity using XOR of all input bits
assign parity = ^in;

endmodule