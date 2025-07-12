module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Maintain the original optimal implementation
    assign q = (a | b) & (c | d);
endmodule