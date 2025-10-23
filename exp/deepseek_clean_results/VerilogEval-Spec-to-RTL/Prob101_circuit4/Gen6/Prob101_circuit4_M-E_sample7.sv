module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);
    wire condition1 = b | c;
    wire condition2 = ~a & d;
    assign q = condition1 | condition2;
endmodule