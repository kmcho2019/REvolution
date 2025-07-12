// Novel approach: Implementing 4-input NAND using NOR gates
module NOR4(
    input  a,
    input  b,
    input  c,
    input  d,
    output y
);
// Implement NOR4 gate using basic NOR logic
assign y = ~(a | b | c | d);

endmodule

module NAND4_NOR(
    input  a,
    input  b,
    input  c,
    input  d,
    output y
);
// Use two NOR4 gates to implement a NAND4 gate
wire nor_out;
NOR4 nor1(
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .y(nor_out)
);
// Invert the NOR output to get NAND output
assign y = ~nor_out;

endmodule

module TopModule(
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y
);
// Instantiate two NAND4_NOR gates
NAND4_NOR nand1(
    .a(p1a),
    .b(p1b),
    .c(p1c),
    .d(p1d),
    .y(p1y)
);

NAND4_NOR nand2(
    .a(p2a),
    .b(p2b),
    .c(p2c),
    .d(p2d),
    .y(p2y)
);

endmodule