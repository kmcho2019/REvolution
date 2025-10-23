// Module to calculate the even parity bit for an 8-bit input byte
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    output parity    // 1-bit output for even parity
);

// Calculate the even parity bit by performing an XOR operation on all input bits
// Utilize Verilog's XOR reduction operator for efficiency
assign parity = ^in;

endmodule