module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);

// At least two of the inputs must be 1 for the output to be 1
assign q = (a & b) | (a & c) | (a & d) | (b & c) | (b & d) | (c & d);

endmodule