module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    wire not_a = ~a;
    wire not_b = ~b;
    wire not_d = ~d;
    
    wire term1 = not_a & not_b;       // ~a & ~b
    wire term2 = a & not_b;           // a & ~b
    wire term3 = b & c & d;           // b & c & d
    wire term4 = not_a & b & c & not_d; // ~a & b & c & ~d
    
    assign out = term1 | term2 | term3 | term4;
endmodule