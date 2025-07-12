// Module for a 3-input AND gate
module AND3(
    input a,
    input b,
    input c,
    output y
);
    assign y = a & b & c;
endmodule

// Module for a 2-input AND gate
module AND2(
    input a,
    input b,
    output y
);
    assign y = a & b;
endmodule

// Module for a 2-input OR gate
module OR2(
    input a,
    input b,
    output y
);
    assign y = a | b;
endmodule

// TopModule implementing the 7458 chip functionality
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
    // Intermediate wires for the outputs of AND gates
    wire and_p1a_p1b_p1c;
    wire and_p1d_p1e_p1f;
    wire and_p2a_p2b;
    wire and_p2c_p2d;

    // Instantiate AND3 gates for p1 inputs
    AND3 and_p1a_p1b_p1c_inst(
        .a(p1a),
        .b(p1b),
        .c(p1c),
        .y(and_p1a_p1b_p1c)
    );
    AND3 and_p1d_p1e_p1f_inst(
        .a(p1d),
        .b(p1e),
        .c(p1f),
        .y(and_p1d_p1e_p1f)
    );

    // Instantiate AND2 gates for p2 inputs
    AND2 and_p2a_p2b_inst(
        .a(p2a),
        .b(p2b),
        .y(and_p2a_p2b)
    );
    AND2 and_p2c_p2d_inst(
        .a(p2c),
        .b(p2d),
        .y(and_p2c_p2d)
    );

    // Instantiate OR2 gates for final outputs
    OR2 or_p1_inst(
        .a(and_p1a_p1b_p1c),
        .b(and_p1d_p1e_p1f),
        .y(p1y)
    );
    OR2 or_p2_inst(
        .a(and_p2a_p2b),
        .b(and_p2c_p2d),
        .y(p2y)
    );
endmodule