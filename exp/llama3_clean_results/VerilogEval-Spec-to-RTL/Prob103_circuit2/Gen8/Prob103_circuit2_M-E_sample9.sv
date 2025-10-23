module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Implement the logic based on K-map simplification
assign q = (~a & ~b & ~c) | (~a & ~b & d) | (~a & b & ~c & ~d) | (~a & b & c & d) | (a & ~b & ~c & ~d) | (a & ~b & c & ~d) | (a & b & ~c & ~d) | (a & b & c & d);

endmodule