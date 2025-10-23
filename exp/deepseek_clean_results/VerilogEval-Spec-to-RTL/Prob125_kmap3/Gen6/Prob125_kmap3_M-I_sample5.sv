module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    wire case_c1 = ~b | a;
    wire case_c0 = a & ~d;
    assign out = c ? case_c1 : case_c0;
endmodule