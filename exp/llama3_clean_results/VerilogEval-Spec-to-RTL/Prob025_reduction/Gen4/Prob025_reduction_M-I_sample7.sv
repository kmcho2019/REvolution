// Module to calculate the even parity bit for an 8-bit input byte
module TopModule(
    input  wire [7:0] in,  // 8-bit input byte
    output wire parity    // 1-bit output for even parity
);

// Calculate the even parity bit by performing an XOR operation on all input bits
// This utilizes Verilog's XOR reduction operator for efficiency and simplicity
assign parity = ^in;

endmodule