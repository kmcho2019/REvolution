module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

// Express the logic based on the Karnaugh map
// The minterms corresponding to output '1' are:
// a'b'c'd', a'b'cd, a'bcd', ab'c'd, ab'cd, abcd, abc'd
assign out = (~a & ~b & ~c & ~d) | 
             (~a & ~b & c & ~d) | 
             (~a & ~b & c & d) | 
             (a & ~b & ~c & ~d) | 
             (a & ~b & c & d) | 
             (a & b & c & d) | 
             (a & b & c & ~d);

endmodule