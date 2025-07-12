// Parameterized module for 3-input AND gate
module And3(
    input a,
    input b,
    input c,
    output y
);
    assign y = a & b & c;
endmodule

// Parameterized module for 2-input AND gate
module And2(
    input a,
    input b,
    output y
);
    assign y = a & b;
endmodule

// Parameterized module for 2-input OR gate
module Or2(
    input a,
    input b,
    output y
);
    assign y = a | b;
endmodule

// TopModule with hierarchical design and PPA optimization
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
    And3 and1(
       .a(p1a),
       .b(p1b),
       .c(p1c),
       .y(and1_out)
    );

    And3 and2(
       .a(p1d),
       .b(p1e),
       .c(p1f),
       .y(and2_out)
    );

    // Instantiate 2-input AND gates
    And2 and3(
       .a(p2a),
       .b(p2b),
       .y(and3_out)
    );

    And2 and4(
       .a(p2c),
       .b(p2d),
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