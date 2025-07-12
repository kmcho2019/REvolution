module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Implement the logic using basic gates
assign out = (a & b & ~c & ~d) | 
             (a & b & ~c & d)  | 
             (a & ~b & c & ~d) | 
             (a & ~b & ~c & d) | 
             (~a & b & c & ~d) | 
             (~a & b & c & d)  | 
             (~a & ~b & c & d) | 
             (~a & ~b & ~c & d);

endmodule