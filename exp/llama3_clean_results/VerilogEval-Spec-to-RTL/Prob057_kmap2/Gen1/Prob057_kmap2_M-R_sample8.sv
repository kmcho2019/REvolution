module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

// Refactored implementation based on the Karnaugh map
assign out = (a & d) | 
             (~a & b & c) | 
             (~a & ~b & ~c & d) | 
             (a & ~b & ~c & d) | 
             (a & b & c & d) | 
             (a & b & ~c & ~d);

endmodule