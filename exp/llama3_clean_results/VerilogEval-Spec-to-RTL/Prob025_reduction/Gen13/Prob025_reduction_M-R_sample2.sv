// Refactored module to calculate the even parity bit for an 8-bit input byte
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    output parity    // 1-bit output for even parity
);

// Directly calculate and assign the even parity bit using XOR operation
assign parity = ^in;

endmodule