module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // q is true when (a OR b) is true AND (c OR d) is true
    assign q = (a | b) & (c | d);
endmodule