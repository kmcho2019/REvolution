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
    wire and1_out, and2_out;  // For p1y
    wire and3_out, and4_out;  // For p2y

    // Instantiate 3-input AND gates for p1y path
    ThreeInputAND and1(.a(p1a), .b(p1b), .c(p1c), .y(and1_out));
    ThreeInputAND and2(.a(p1d), .b(p1e), .c(p1f), .y(and2_out));

    // Instantiate 2-input AND gates for p2y path
    TwoInputAND and3(.a(p2a), .b(p2b), .y(and3_out));
    TwoInputAND and4(.a(p2c), .b(p2d), .y(and4_out));

    // OR operations
    assign p1y = and1_out | and2_out;
    assign p2y = and3_out | and4_out;
endmodule