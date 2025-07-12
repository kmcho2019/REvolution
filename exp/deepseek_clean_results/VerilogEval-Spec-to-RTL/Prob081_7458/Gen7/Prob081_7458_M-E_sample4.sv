module TopModule (
    input p1a, p1b, p1c, p1d, p1e, p1f,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);
    // Instantiate AND gates for p1y path
    wire p1_and1_out, p1_and2_out;
    AND3 p1_and1(.a(p1a), .b(p1b), .c(p1c), .out(p1_and1_out));
    AND3 p1_and2(.a(p1d), .b(p1e), .c(p1f), .out(p1_and2_out));
    
    // Instantiate AND gates for p2y path
    wire p2_and1_out, p2_and2_out;
    AND2 p2_and1(.a(p2a), .b(p2b), .out(p2_and1_out));
    AND2 p2_and2(.a(p2c), .b(p2d), .out(p2_and2_out));
    
    // Instantiate OR gates
    OR2 p1_or(.a(p1_and1_out), .b(p1_and2_out), .out(p1y));
    OR2 p2_or(.a(p2_and1_out), .b(p2_and2_out), .out(p2y));
endmodule

// 3-input AND gate module
module AND3(input a, b, c, output out);
    assign out = a & b & c;
endmodule

// 2-input AND gate module
module AND2(input a, b, output out);
    assign out = a & b;
endmodule

// 2-input OR gate module
module OR2(input a, b, output out);
    assign out = a | b;
endmodule