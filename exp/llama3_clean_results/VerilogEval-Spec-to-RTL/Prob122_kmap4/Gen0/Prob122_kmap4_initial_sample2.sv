module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

// The Karnaugh map represents the following logic:
// out = (a & ~b & ~c & ~d) | (~a & b & ~c & ~d) | (~a & ~b & c & ~d) | (~a & ~b & ~c & d) | 
//      (a & b & c & ~d) | (~a & b & c & ~d) | (a & ~b & c & d) | (~a & ~b & c & d);
// Simplifying the above expression to get the desired output.
assign out = (~a & ~c & (b ^ d)) | (~b & ~d & (a ^ c));

endmodule