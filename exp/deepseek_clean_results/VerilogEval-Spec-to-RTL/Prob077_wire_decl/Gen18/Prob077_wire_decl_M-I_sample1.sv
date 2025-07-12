module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);
    wire ab_and = a & b;  // First AND gate
    wire cd_and = c & d;  // Second AND gate
    
    assign out = ab_and | cd_and;  // OR gate
    assign out_n = ~out;          // Inverted output
endmodule