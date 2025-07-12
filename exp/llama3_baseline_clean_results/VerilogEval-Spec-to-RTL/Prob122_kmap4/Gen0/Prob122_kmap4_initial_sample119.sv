module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

// Direct implementation based on observed patterns in the Karnaugh map
assign out = (a & b & ~c & ~d) | (~a & ~b & c & ~d) | (~a & b & ~c & d) | (~a & ~b & ~c & ~d) | (~a & b & c & d) | (~a & ~b & c & d);

endmodule