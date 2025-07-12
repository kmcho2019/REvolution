module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Implement the logic based on the Karnaugh map
// The Karnaugh map provided corresponds to the following simplified logic:
// out = (a & ~b & ~c & ~d) | (~a & b & ~c & ~d) | (~a & ~b & c & ~d) | (~a & ~b & ~c & d) | 
//       (~a & b & c & d) | (a & b & c & d) | (a & ~b & c & d) | (~a & b & ~c & d);
// However, this needs to be simplified based on the map provided.
// A more accurate simplification directly from the map considering the '1's would be:
// out = (~a & ~c & ~d) | (~a & b & c & d) | (a & ~c & d) | (~b & c & d);
assign out = (~a & ~c & ~d) | (~a & b & c & d) | (a & ~c & d) | (~b & c & d);

endmodule