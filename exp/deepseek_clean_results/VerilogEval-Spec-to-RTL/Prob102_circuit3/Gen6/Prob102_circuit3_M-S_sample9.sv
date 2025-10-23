module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Simplified logic: q = (b & d) | (a & c)
    assign q = (b & d) | (a & c);
endmodule