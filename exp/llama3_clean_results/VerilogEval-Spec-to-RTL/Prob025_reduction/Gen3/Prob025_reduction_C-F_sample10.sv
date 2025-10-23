// TopModule: Calculates the even parity bit for an 8-bit input byte.
module TopModule(
    input  [7:0] in,  // 8-bit input
    output parity    // 1-bit output for parity
);

// Calculate the parity bit by performing an XOR operation on all input bits.
assign parity = ^in;

endmodule