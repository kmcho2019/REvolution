module AND3 (
    input a, b, c,
    output y
);
    assign y = a & b & c;
endmodule

module AND2 (
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
    // Intermediate signals for AND outputs
    wire and3_1_out, and3_2_out;  // For p1y path
    wire and2_1_out, and2_2_out;  // For p2y path

    // 3-input AND gates for p1y
    AND3 p1_and1(.a(p1a), .b(p1b), .c(p1c), .y(and3_1_out));
    AND3 p1_and2(.a(p1d), .b(p1e), .c(p1f), .y(and3_2_out));

    // 2-input AND gates for p2y
    AND2 p2_and1(.a(p2a), .b(p2b), .y(and2_1_out));
    AND2 p2_and2(.a(p2c), .b(p2d), .y(and2_2_out));

    // Direct OR implementations for optimal performance
    assign p1y = and3_1_out | and3_2_out;
    assign p2y = and2_1_out | and2_2_out;
endmodule