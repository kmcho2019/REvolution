module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);
    wire and_ab = a & b;  // First AND gate (a AND b)
    wire and_cd = c & d;  // Second AND gate (c AND d)
    
    assign out = and_ab | and_cd;  // OR of both AND outputs
    assign out_n = ~out;           // Inverted output
endmodule