module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    wire case_c1_b0 = c & ~b;
    wire case_c1_b1 = c & b & a;
    wire case_c0 = ~c & a;
    
    assign out = case_c1_b0 | case_c1_b1 | case_c0;
endmodule