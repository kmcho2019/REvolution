module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Output is high when:
    // (a OR b) AND (c OR d)
    assign q = (a | b) & (c | d);

endmodule