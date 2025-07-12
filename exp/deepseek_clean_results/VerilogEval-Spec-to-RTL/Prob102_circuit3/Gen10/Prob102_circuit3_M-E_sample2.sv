module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Check conditions in priority order
    assign q = (b & d) | (a & d) | (b & c) | (a & c);
endmodule