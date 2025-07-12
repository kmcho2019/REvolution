module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

// Implementation of the Karnaugh map using Boolean logic
assign out = (a & ~b & c & ~d) | (~a & ~b & ~c & ~d) | (~a & b & c & ~d) | (~a & ~b & c & d) | (a & b & c & d) | (a & b & ~c & d) | (~a & b & ~c & ~d);

endmodule