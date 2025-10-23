// Module to calculate the even parity bit for an 8-bit input byte using XOR reduction operator
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    output parity    // 1-bit output for even parity
);

// Calculate the parity bit using XOR reduction operator
assign parity = ^in;

endmodule