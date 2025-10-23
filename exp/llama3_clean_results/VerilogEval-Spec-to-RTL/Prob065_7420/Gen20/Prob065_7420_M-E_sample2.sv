// Define the NOT gate module
module NOT(
    input  a,
    output y
);
assign y = ~a;
endmodule

// Define the AND2 gate module
module AND2(
    input  a,
    input  b,
    output y
);
assign y = a & b;
endmodule

// Define the AND3 gate module using AND2 gates
module AND3(
    input  a,
    input  b,
    input  c,
    output y
);
wire ab;
AND2 and1(
 .a(a),
 .b(b),
 .y(ab)
);
AND2 and2(
 .a(ab),
 .b(c),
 .y(y)
);
endmodule

// Define the AND4 gate module using AND3 and AND2 gates
module AND4(
    input  a,
    input  b,
    input  c,
    input  d,
    output y
);
wire abc;
AND3 and1(
 .a(a),
 .b(b),
 .c(c),
 .y(abc)
);
AND2 and2(
 .a(abc),
 .b(d),
 .y(y)
);
endmodule

// Define the NAND4 gate module using AND4 and NOT gates
module NAND4(
    input  a,
    input  b,
    input  c,
    input  d,
    output y
);
wire and4_out;
AND4 and4(
 .a(a),
 .b(b),
 .c(c),
 .d(d),
 .y(and4_out)
);
NOT not1(
 .a(and4_out),
 .y(y)
);
endmodule

// Define the TopModule that instantiates two NAND4 gates
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
// Instantiate two NAND4 gates for the 7420 chip's functionality
NAND4 nand1(
 .a(p1a),
 .b(p1b),
 .c(p1c),
 .d(p1d),
 .y(p1y)
);

NAND4 nand2(
 .a(p2a),
 .b(p2b),
 .c(p2c),
 .d(p2d),
 .y(p2y)
);
endmodule