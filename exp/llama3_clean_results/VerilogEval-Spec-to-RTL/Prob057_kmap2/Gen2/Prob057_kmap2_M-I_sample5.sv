module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Directly implement the simplified logic based on the Karnaugh map
assign out = (a & b & ~c & ~d) | (~a & b & c & ~d) | (a & ~b & c & ~d) | (a & ~b & ~c & d) | (~a & b & ~c & d) | (a & b & c & d) | (a & b & ~c & d);

// Alternatively, simplify the logic based on observation
// assign out = (a & b & ~c & ~d) | (~a & b & c & ~d) | (a & ~b & c & ~d) | (a & ~b & ~c & d) | (~a & b & ~c & d) | (a & b & c & d);
endmodule