module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Implementing the logic based on the Karnaugh map
assign out = (a & b & ~d) | (~a & b & c) | (~a & ~b & c & ~d) | (~a & ~b & ~c & d) | (a & ~b & ~c & d) | (a & b & c & d);

endmodule