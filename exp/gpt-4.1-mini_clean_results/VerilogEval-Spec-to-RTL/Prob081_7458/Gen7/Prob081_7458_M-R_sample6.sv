module And3 (
    input  a,
    input  b,
    input  c,
    output y
);
    assign y = a & b & c;
endmodule

module And2 (
    input  a,
    input  b,
    output y
);
    assign y = a & b;
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

    wire and1_p1, and2_p1;
    wire and1_p2, and2_p2;

    // Instantiate 3-input AND gates for p1
    And3 u_and3_1 (.a(p1a), .b(p1b), .c(p1c), .y(and1_p1));
    And3 u_and3_2 (.a(p1d), .b(p1e), .c(p1f), .y(and2_p1));

    // Instantiate 2-input AND gates for p2
    And2 u_and2_1 (.a(p2a), .b(p2b), .y(and1_p2));
    And2 u_and2_2 (.a(p2c), .b(p2d), .y(and2_p2));

    // OR outputs of AND gates
    assign p1y = and1_p1 | and2_p1;
    assign p2y = and1_p2 | and2_p2;

endmodule