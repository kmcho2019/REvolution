module TopModule(
    input p1a,
    input p1b,
    input p1c,
    input p1d,
    input p1e,
    input p1f,
    input p2a,
    input p2b,
    input p2c,
    input p2d,
    output p1y,
    output p2y
);

    // Instantiate AND3 modules for p1y path
    wire and1_out, and2_out;
    AND3 and3_1(.a(p1a), .b(p1b), .c(p1c), .out(and1_out));
    AND3 and3_2(.a(p1d), .b(p1e), .c(p1f), .out(and2_out));
    
    // Instantiate AND2 modules for p2y path
    wire and3_out, and4_out;
    AND2 and2_1(.a(p2a), .b(p2b), .out(and3_out));
    AND2 and2_2(.a(p2c), .b(p2d), .out(and4_out));
    
    // Instantiate OR2 modules for final outputs
    OR2 or1(.a(and1_out), .b(and2_out), .out(p1y));
    OR2 or2(.a(and3_out), .b(and4_out), .out(p2y));

endmodule

// 3-input AND gate submodule
module AND3(
    input a,
    input b,
    input c,
    output out
);
    assign out = a & b & c;
endmodule

// 2-input AND gate submodule
module AND2(
    input a,
    input b,
    output out
);
    assign out = a & b;
endmodule

// 2-input OR gate submodule
module OR2(
    input a,
    input b,
    output out
);
    assign out = a | b;
endmodule