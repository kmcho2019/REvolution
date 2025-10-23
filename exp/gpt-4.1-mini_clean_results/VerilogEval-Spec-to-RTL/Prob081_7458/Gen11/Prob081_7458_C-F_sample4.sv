// Basic 2-input AND gate module
module And2 (
    input  a,
    input  b,
    output y
);
    assign y = a & b;
endmodule

// 3-input AND gate built from two 2-input AND gates (structural)
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

    // Wires for 3-input AND outputs (p1)
    wire p1_and1_out, p1_and2_out;

    // Instantiate two 3-input AND gates for p1 groups
    And3 and_p1_1 (.a(p1a), .b(p1b), .c(p1c), .y(p1_and1_out));
    And3 and_p1_2 (.a(p1d), .b(p1e), .c(p1f), .y(p1_and2_out));

    // Direct assign for 2-input AND gates (p2)
    wire p2_and1_out = p2a & p2b;
    wire p2_and2_out = p2c & p2d;

    // OR outputs using direct assign statements for minimal hierarchy
    assign p1y = p1_and1_out | p1_and2_out;
    assign p2y = p2_and1_out | p2_and2_out;

endmodule