module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);
    wire and_ab = a & b;  // First AND gate output
    wire and_cd = c & d;  // Second AND gate output
    
    assign out = and_ab | and_cd;  // OR operation
    assign out_n = ~out;           // Inverted output
endmodule