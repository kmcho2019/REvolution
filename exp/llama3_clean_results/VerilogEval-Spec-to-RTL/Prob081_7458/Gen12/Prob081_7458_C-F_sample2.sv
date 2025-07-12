// Parameterized module for N-input AND gate
module AndN(
    input [2:0] size,
    input [2:0] a,
    input [2:0] b,
    input [2:0] c,
    output y
);
    assign y = (size == 3) ? (a & b & c) : (size == 2) ? (a & b) : 1'b0;
endmodule

// Parameterized module for 2-input OR gate
module Or2(
    input a,
    input b,
    output y
);
    assign y = a | b;
endmodule

// TopModule with hierarchical design
module TopModule(
    input p1a,
    input p1b,
    input p1c,
    input p1d,
    input p1e,
    input p1f,
    input p2a,
    input p2b,
    input p2c,
    input p2d,
    output p1y,
    output p2y
);
    wire and1_out, and2_out, and3_out, and4_out;

    // Instantiate 3-input AND gates
    AndN and1(
       .size(3'b100),
       .a(p1a),
       .b(p1b),
       .c(p1c),
       .y(and1_out)
    );

    AndN and2(
       .size(3'b100),
       .a(p1d),
       .b(p1e),
       .c(p1f),
       .y(and2_out)
    );

    // Instantiate 2-input AND gates
    AndN and3(
       .size(3'b010),
       .a(p2a),
       .b(p2b),
       .c(1'b0),
       .y(and3_out)
    );

    AndN and4(
       .size(3'b010),
       .a(p2c),
       .b(p2d),
       .c(1'b0),
       .y(and4_out)
    );

    // Instantiate 2-input OR gates
    Or2 or1(
       .a(and1_out),
       .b(and2_out),
       .y(p1y)
    );

    Or2 or2(
       .a(and3_out),
       .b(and4_out),
       .y(p2y)
    );
endmodule