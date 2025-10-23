module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    wire case_c0 = a & ~b & ~d;  // c=0: only true for ab=10/11 when d=0
    wire case_c1 = ~(~a & b);    // c=1: false only when ab=01
    assign out = c ? case_c1 : case_c0;
endmodule