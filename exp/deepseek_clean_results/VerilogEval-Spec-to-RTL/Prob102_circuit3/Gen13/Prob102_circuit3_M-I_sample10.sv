module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Already optimal implementation
    assign q = (a | b) & (c | d);
endmodule