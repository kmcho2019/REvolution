// Basic 2-input AND gate module
module And2 (
    input  a,
    input  b,
    output y
);
    assign y = a & b;
endmodule

// 3-input AND gate built from two 2-input AND gates
module And3 (
    input  a,
    input  b,
    input  c,
    output y
);
    wire and_ab;
    And2 and1 (.a(a), .b(b), .y(and_ab));
    And2 and2 (.a(and_ab), .b(c), .y(y));
endmodule

module TopModule (
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p1e,
    input  p1f,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y
);

    // Intermediate wires for p1 3-input AND gates
    wire p1_and1_out, p1_and2_out;

    // Intermediate wires for p2 2-input AND gates
    wire p2_and1_out, p2_and2_out;

    // Instantiate 3-input AND gates for p1 output
    And3 and_p1_1 (.a(p1a), .b(p1b), .c(p1c), .y(p1_and1_out));
    And3 and_p1_2 (.a(p1d), .b(p1e), .c(p1f), .y(p1_and2_out));

    // Instantiate 2-input AND gates for p2 output
    And2 and_p2_1 (.a(p2a), .b(p2b), .y(p2_and1_out));
    And2 and_p2_2 (.a(p2c), .b(p2d), .y(p2_and2_out));

    // Use assign statements for final OR outputs to reduce module overhead
    assign p1y = p1_and1_out | p1_and2_out;
    assign p2y = p2_and1_out | p2_and2_out;

endmodule