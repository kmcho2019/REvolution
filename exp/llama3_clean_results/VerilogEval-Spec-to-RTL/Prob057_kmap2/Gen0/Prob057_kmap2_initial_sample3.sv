module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

// Implementing the circuit based on the Karnaugh map
assign out = (a & b & ~c & ~d) | 
             (a & ~b & c & ~d) | 
             (~a & b & c & ~d) | 
             (~a & b & ~c & d) | 
             (a & b & c & d) | 
             (a & ~b & ~c & d) | 
             (~a & ~b & ~c & d);

endmodule