module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // q is true when (a OR b) AND (c OR d)
    assign q = (a | b) & (c | d);
endmodule