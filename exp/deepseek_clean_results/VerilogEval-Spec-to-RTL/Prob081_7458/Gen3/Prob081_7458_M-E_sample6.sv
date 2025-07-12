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

module OR2 (
    input a, b,
    output y
);
    assign y = a | b;
endmodule

module TopModule (
    input p1a, p1b, p1c, p1d, p1e, p1f,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);

    wire and3_1_out, and3_2_out;
    wire and2_1_out, and2_2_out;

    // First 3-input AND for p1y
    AND3 and3_1 (.a(p1a), .b(p1b), .c(p1c), .y(and3_1_out));
    
    // Second 3-input AND for p1y
    AND3 and3_2 (.a(p1d), .b(p1e), .c(p1f), .y(and3_2_out));
    
    // OR for p1y
    OR2 or1 (.a(and3_1_out), .b(and3_2_out), .y(p1y));
    
    // First 2-input AND for p2y
    AND2 and2_1 (.a(p2a), .b(p2b), .y(and2_1_out));
    
    // Second 2-input AND for p2y
    AND2 and2_2 (.a(p2c), .b(p2d), .y(and2_2_out));
    
    // OR for p2y
    OR2 or2 (.a(and2_1_out), .b(and2_2_out), .y(p2y));

endmodule