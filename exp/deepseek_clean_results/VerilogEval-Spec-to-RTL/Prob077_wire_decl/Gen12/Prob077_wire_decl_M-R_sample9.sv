module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);
    wire and_ab, and_cd;
    
    // First layer AND operations
    assign and_ab = a & b;
    assign and_cd = c & d;
    
    // Second layer OR operation and inversion
    assign out = and_ab | and_cd;
    assign out_n = ~out;
endmodule