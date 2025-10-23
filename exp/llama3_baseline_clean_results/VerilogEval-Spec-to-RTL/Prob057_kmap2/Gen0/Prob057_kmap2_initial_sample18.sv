module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

// Simplified expression based on the Karnaugh map
assign out = (a & ~b & ~c & ~d) | 
             (~a & b & ~c & ~d) | 
             (~a & b & c & ~d) | 
             (~a & b & c & d) | 
             (~a & b & ~c & d) | 
             (a & b & c & d) | 
             (a & ~b & ~c & d);

endmodule