// Module Mux25Bit implements a 2-1 multiplexer for 25-bit inputs.
module Mux25Bit(
    input [24:0] a,  // 25-bit input 'a'
    input [24:0] b,  // 25-bit input 'b'
    input sel,       // select line
    output [24:0] out // 25-bit output
);

assign out = sel? b : a;

endmodule

// Module TopModule implements a 2-1 multiplexer for 100-bit inputs.
module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Instantiate four Mux25Bit modules to handle the 100-bit input.
Mux25Bit mux0(
    .a(a[24:0]),   // 25-bit input 'a' for the first block
    .b(b[24:0]),   // 25-bit input 'b' for the first block
    .sel(sel),     // select line
    .out(out[24:0]) // 25-bit output for the first block
);

Mux25Bit mux1(
    .a(a[49:25]),  // 25-bit input 'a' for the second block
    .b(b[49:25]),  // 25-bit input 'b' for the second block
    .sel(sel),     // select line
    .out(out[49:25]) // 25-bit output for the second block
);

Mux25Bit mux2(
    .a(a[74:50]),  // 25-bit input 'a' for the third block
    .b(b[74:50]),  // 25-bit input 'b' for the third block
    .sel(sel),     // select line
    .out(out[74:50]) // 25-bit output for the third block
);

Mux25Bit mux3(
    .a(a[99:75]),  // 25-bit input 'a' for the fourth block
    .b(b[99:75]),  // 25-bit input 'b' for the fourth block
    .sel(sel),     // select line
    .out(out[99:75]) // 25-bit output for the fourth block
);

endmodule