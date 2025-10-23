module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    wire a_n, b_n, c_n, d_n;
    wire term1, term2, term3, term4, term5;
    
    assign a_n = ~a;
    assign b_n = ~b;
    assign c_n = ~c;
    assign d_n = ~d;
    
    assign term1 = ~(a ^ b);               // a XNOR b
    assign term2 = b & c;                  // b AND c
    assign term3 = a_n & c_n;              // a' AND c'
    assign term4 = a_n & d_n;              // a' AND d'
    assign term5 = a & b_n & d;            // a AND b' AND d
    
    assign out = term1 | term2 | term3 | term4 | term5;
endmodule