// Module A: z = (x ^ y) & x implemented using basic gates
module A(input x, input y, output z);
    wire xy_or, xy_and, xor_temp;
    assign xy_or = x | y;
    assign xy_and = x & y;
    assign xor_temp = xy_or & ~xy_and; // x ^ y = (x | y) & ~(x & y)
    assign z = xor_temp & x;
endmodule

// Module B: z = XNOR(x,y) implemented using basic gates
module B(input x, input y, output z);
    wire x_not, y_not, and1, and2;
    assign x_not = ~x;
    assign y_not = ~y;
    assign and1 = x & y;
    assign and2 = x_not & y_not;
    assign z = and1 | and2; // XNOR: (x & y) | (~x & ~y)
endmodule

// Top-level module with explicit gate instances for OR, AND, XOR
module top(input x, input y, output z);
    wire a1_out, a2_out, b1_out, b2_out;
    wire or_out, and_out;

    // Instantiate two A modules
    A A1(.x(x), .y(y), .z(a1_out));
    A A2(.x(x), .y(y), .z(a2_out));

    // Instantiate two B modules
    B B1(.x(x), .y(y), .z(b1_out));
    B B2(.x(x), .y(y), .z(b2_out));

    // OR gate for first pair (a1_out, b1_out)
    or or_gate(or_out, a1_out, b1_out);

    // AND gate for second pair (a2_out, b2_out)
    and and_gate(and_out, a2_out, b2_out);

    // XOR gate for outputs of OR and AND gates
    xor xor_gate(z, or_out, and_out);
endmodule