module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

// Improved implementation
assign out = (a & ~c & ~d) | 
             (~a & ~b & c & ~d) | 
             (~a & b & c & d) | 
             (b & c & d) | 
             (a & b & d) | 
             (a & ~b & ~c & d);

endmodule