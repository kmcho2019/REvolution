module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

// Implement the Karnaugh map using logical operations
assign out = (a & b & ~c & ~d) | (~a & ~b & c & ~d) | (~a & b & c & ~d) | (a & ~b & ~c & d) | (a & b & c & d) | (~a & ~b & ~c & ~d) | (~a & b & ~c & d);

endmodule