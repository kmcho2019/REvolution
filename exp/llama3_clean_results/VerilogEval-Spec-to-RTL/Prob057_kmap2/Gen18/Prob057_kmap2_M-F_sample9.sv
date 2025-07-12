module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Directly implement the logic based on the corrected understanding of the Karnaugh map
assign out = (a & ~c) | (~a & b & ~c) | (a & b & c & d) | (~a & b & c & d);

endmodule