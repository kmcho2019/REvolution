module TopModule (
    input p1a, p1b, p1c, p1d, p1e, p1f,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);

    // Internal wires for AND gate outputs
    wire and3_1_out, and3_2_out;
    wire and2_1_out, and2_2_out;

    // Instantiate 3-input AND gates for p1y path
    AND3 and3_1 (.a(p1a), .b(p1b), .c(p1c), .y(and3_1_out));
    AND3 and3_2 (.a(p1d), .b(p1e), .c(p1f), .y(and3_2_out));

    // Instantiate 2-input AND gates for p2y path
    AND2 and2_1 (.a(p2a), .b(p2b), .y(and2_1_out));
    AND2 and2_2 (.a(p2c), .b(p2d), .y(and2_2_out));

    // Instantiate OR gates
    OR2 or1 (.a(and3_1_out), .b(and3_2_out), .y(p1y));
    OR2 or2 (.a(and2_1_out), .b(and2_2_out), .y(p2y));

endmodule

// 3-input AND gate submodule
module AND3 (
    input a, b, c,
    output y
);
    assign y = a & b & c;
endmodule

// 2-input AND gate submodule
module AND2 (
    input a, b,
    output y
);
    assign y = a & b;
endmodule

// 2-input OR gate submodule
module OR2 (
    input a, b,
    output y
);
    assign y = a | b;
endmodule