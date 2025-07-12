module TopModule(
    input p1a, p1b, p1c, p1d, p1e, p1f,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);

    // Instantiate AND3 gates for p1y path
    wire and1_out, and2_out;
    AND3 and1(.a(p1a), .b(p1b), .c(p1c), .out(and1_out));
    AND3 and2(.a(p1d), .b(p1e), .c(p1f), .out(and2_out));
    
    // Instantiate AND2 gates for p2y path
    wire and3_out, and4_out;
    AND2 and3(.a(p2a), .b(p2b), .out(and3_out));
    AND2 and4(.a(p2c), .b(p2d), .out(and4_out));
    
    // Instantiate OR gates for final outputs
    OR2 or1(.a(and1_out), .b(and2_out), .out(p1y));
    OR2 or2(.a(and3_out), .b(and4_out), .out(p2y));

endmodule

// 3-input AND gate module
module AND3(
    input a, b, c,
    output out
);
    assign out = a & b & c;
endmodule

// 2-input AND gate module
module AND2(
    input a, b,
    output out
);
    assign out = a & b;
endmodule

// 2-input OR gate module
module OR2(
    input a, b,
    output out
);
    assign out = a | b;
endmodule