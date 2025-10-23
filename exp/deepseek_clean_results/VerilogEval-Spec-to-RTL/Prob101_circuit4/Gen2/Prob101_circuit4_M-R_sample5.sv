module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // q is 0 only in two cases:
    // 1. All inputs are 0
    // 2. a=1, b=0, c=0 (d is don't care)
    assign q = ~((~a & ~b & ~c & ~d) | (a & ~b & ~c));
endmodule