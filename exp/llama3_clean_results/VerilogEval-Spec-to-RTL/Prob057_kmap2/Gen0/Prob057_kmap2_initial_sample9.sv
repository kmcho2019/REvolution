module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

// Implementation based on the simplified Karnaugh map
assign out = (a & ~b & ~c & ~d) | 
             (a & ~b & ~c & d)  | 
             (a & b & c & d)    | 
             (a & b & ~c & ~d)  | 
             (~a & b & c & d)   | 
             (~a & ~b & c & ~d) | 
             (a & b & ~c & d);

endmodule