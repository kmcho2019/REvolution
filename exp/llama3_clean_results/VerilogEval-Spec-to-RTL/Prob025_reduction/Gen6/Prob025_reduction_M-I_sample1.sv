module TopModule(
    input  wire [7:0] in,  // Input 8-bit byte
    output wire parity     // Output parity bit
);

// Compute the even parity bit using XOR reduction
assign parity = ^in;

endmodule