module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Simplified minimal sum-of-products expression derived from the K-map
assign out = 
    (~c & ~d) |
    (~c & ~b & d) |
    (c & ~a & ~d) |
    (c & d & (a | b));

endmodule