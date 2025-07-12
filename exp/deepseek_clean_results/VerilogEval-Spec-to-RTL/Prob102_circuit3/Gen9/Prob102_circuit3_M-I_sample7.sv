module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // NAND-NAND implementation of (a|b)&(c|d)
    assign q = ~((~(a | b)) | (~(c | d)));
endmodule