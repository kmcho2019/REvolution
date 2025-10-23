module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    wire case_c0 = (a ^ b) & ~d;  // c=0 case
    wire case_c1 = ~(a & ~b);      // c=1 case
    assign out = c ? case_c1 : case_c0;
endmodule