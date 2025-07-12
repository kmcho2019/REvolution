module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);

assign q = ~(a & b & c & d) & ~(a & b & ~c & ~d) & ~(~a & ~b & c) & ~(~a & b & ~c & ~d) | (~a & ~b & ~c & ~d) | (a & ~b & c & d) | (a & ~b & ~c & d) | (~a & b & ~c & d) | (~a & b & c & d) | (a & b & ~c & d) | (a & b & c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Alternatively, a simplified version
assign q = ~(a & b & c & ~d) & ~(~a & b & c & d) & ~(~a & ~b & c & d) & ~(a & ~b & c & ~d) & ~(a & b & ~c & d) | (~a & ~b & ~c & ~d);

// Further simplified
assign q = (~a | ~b | ~c | d) & (~a | ~b | c | ~d) & (~a | b | ~c | ~d) & (~a | b | ~c | d) & (~a | b | c | ~d) | (~a & ~b & ~c & ~d);

endmodule