module TopModule (
    input a,
    input b,
    output out
);
    // Transmission gate based XNOR implementation
    wire out_n;
    wire a_n = ~a;
    wire b_n = ~b;
    
    // Transmission gates
    tranif1 (out, 1'b1, a & b);    // Both high
    tranif1 (out, 1'b0, a_n & b_n); // Both low
    tranif0 (out_n, 1'b1, a & b_n); // a high, b low
    tranif0 (out_n, 1'b1, a_n & b); // a low, b high
    
    // Weak keeper
    not (weak1, out_n);
    not (weak2, weak1);
    buf (out, weak2);
endmodule