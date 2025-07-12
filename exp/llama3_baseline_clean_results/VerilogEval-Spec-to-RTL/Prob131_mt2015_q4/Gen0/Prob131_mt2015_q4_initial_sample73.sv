module top_level_module(
    input x,
    input y,
    output z
);

// Module A implements the boolean function z = (x^y) & x
module module_a(
    input x,
    input y,
    output z
);
    assign z = (x ^ y) & x;
endmodule

// Module B implements the boolean function z = (x == y)
module module_b(
    input x,
    input y,
    output z
);
    assign z = (x == y);
endmodule

// Instantiate two Module A and two Module B
module_a a1(
   .x(x),
   .y(y),
   .z()
);
module_b b1(
   .x(x),
   .y(y),
   .z()
);
module_a a2(
   .x(x),
   .y(y),
   .z()
);
module_b b2(
   .x(x),
   .y(y),
   .z()
);

// Declare wires for connections
wire w1, w2;

// Connect outputs of first A and B to OR gate
assign w1 = a1.z | b1.z;

// Connect outputs of second A and B to AND gate
assign w2 = a2.z & b2.z;

// Connect outputs of OR and AND to XOR gate
assign z = w1 ^ w2;

endmodule