module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Direct implementation based on simplified observation of the Karnaugh map
assign out = (~a & ~b) | (~a & b & ~d) | (~a & b & c) | (a & ~c & ~d) | (a & b & c) | (a & b & ~c & d);

endmodule