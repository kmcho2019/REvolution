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
    // Intermediate wires with descriptive names
    wire p1_and1_out, p1_and2_out;
    wire p2_and1_out, p2_and2_out;

    // First OR path (p1y): Two 3-input ANDs
    ThreeInputAND p1_first_and(.a(p1a), .b(p1b), .c(p1c), .y(p1_and1_out));
    ThreeInputAND p1_second_and(.a(p1d), .b(p1e), .c(p1f), .y(p1_and2_out));
    assign p1y = p1_and1_out | p1_and2_out;

    // Second OR path (p2y): Two 2-input ANDs
    TwoInputAND p2_first_and(.a(p2a), .b(p2b), .y(p2_and1_out));
    TwoInputAND p2_second_and(.a(p2c), .b(p2d), .y(p2_and2_out));
    assign p2y = p2_and1_out | p2_and2_out;
endmodule