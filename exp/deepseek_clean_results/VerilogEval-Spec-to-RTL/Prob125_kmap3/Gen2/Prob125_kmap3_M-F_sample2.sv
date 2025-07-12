module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    wire case_c0 = a & ~d;        // c=0 case: output 1 only when a=1 and d=0 (matches cd=00)
    wire case_c1 = ~(~a & b);     // c=1 case: output 0 only when ab=01, else 1
    assign out = c ? case_c1 : case_c0;
endmodule