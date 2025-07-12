module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);

assign q = ~(a & b & c & d) & (a | b | c | d | ~(a & b & c) & ~(a & b & d) & ~(a & c & d) & ~(b & c & d));

// Alternatively, the following code could be used to generate the output q
// Based on the truth table given
assign q = (a & ~b & ~c & ~d) | (~a & b & ~c & ~d) | (~a & ~b & c & ~d) | (~a & ~b & ~c & d) | (~a & b & c & d) | (a & ~b & c & d) | (a & b & ~c & d) | (~a & b & c & d) | (~a & b & ~c & d) | (a & b & ~c & ~d) | (~a & ~b & ~c & ~d);

endmodule