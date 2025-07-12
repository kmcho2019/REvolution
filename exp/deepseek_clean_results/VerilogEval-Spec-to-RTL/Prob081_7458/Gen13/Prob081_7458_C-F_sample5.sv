module ThreeInputAND (
    input a, b, c,
    output y
);
    assign y = a & b & c;
endmodule

module TwoInputAND (
    input a, b,
    output y
);
    assign y = a & b;
endmodule

module TopModule (
    input p1a, p1b, p1c, p1d, p1e, p1f,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);
    // Directly connect AND outputs to OR operations
    wire p1_and1_out, p1_and2_out;
    wire p2_and1_out, p2_and2_out;

    // 3-input AND gates for p1y
    ThreeInputAND p1_and1(.a(p1a), .b(p1b), .c(p1c), .y(p1_and1_out));
    ThreeInputAND p1_and2(.a(p1d), .b(p1e), .c(p1f), .y(p1_and2_out));

    // 2-input AND gates for p2y
    TwoInputAND p2_and1(.a(p2a), .b(p2b), .y(p2_and1_out));
    TwoInputAND p2_and2(.a(p2c), .b(p2d), .y(p2_and2_out));

    // Direct OR implementations
    assign p1y = p1_and1_out | p1_and2_out;
    assign p2y = p2_and1_out | p2_and2_out;
endmodule