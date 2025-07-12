module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

assign q = ~(a & b & c) & ~(a & b & d) & ~(b & c & d) & ~(a & c & d) & ~(a & b) | (a & ~b & ~c & ~d) | (b & ~a & ~c & ~d) | (c & ~a & ~b & ~d) | (d & ~a & ~b & ~c) | (~a & ~b & ~c & d) | (~a & ~b & c & ~d) | (~a & b & ~c & ~d) | (~a & b & ~c & d) | (~a & b & c & ~d) | (~a & ~b & c & d) | (a & ~b & ~c & d) | (a & ~b & c & ~d) | (a & ~b & c & d) | (a & b & ~c & ~d) | (a & b & ~c & d) | (a & b & c & ~d) | (a & b & c & d);

endmodule