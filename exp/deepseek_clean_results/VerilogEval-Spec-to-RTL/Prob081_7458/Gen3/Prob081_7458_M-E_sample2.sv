module TopModule (
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

    // Internal wires for AND gate outputs
    wire and1_out, and2_out, and3_out, and4_out;
    
    // Instantiate 3-input AND gates for p1y path
    AND3 and1(.a(p1a), .b(p1b), .c(p1c), .out(and1_out));
    AND3 and2(.a(p1d), .b(p1e), .c(p1f), .out(and2_out));
    
    // Instantiate 2-input AND gates for p2y path
    AND2 and3(.a(p2a), .b(p2b), .out(and3_out));
    AND2 and4(.a(p2c), .b(p2d), .out(and4_out));
    
    // Instantiate OR gates
    OR2 or1(.a(and1_out), .b(and2_out), .out(p1y));
    OR2 or2(.a(and3_out), .b(and4_out), .out(p2y));

endmodule

// 3-input AND gate module
module AND3(
    input a,
    input b,
    input c,
    output out
);
    assign out = a & b & c;
endmodule

// 2-input AND gate module
module AND2(
    input a,
    input b,
    output out
);
    assign out = a & b;
endmodule

// 2-input OR gate module
module OR2(
    input a,
    input b,
    output out
);
    assign out = a | b;
endmodule