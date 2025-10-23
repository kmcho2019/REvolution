module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = (~a & ~b & c & ~d) | 
             (~a & b & c & d) | 
             (b & c & d) | 
             (a & ~b & ~c & ~d) | 
             (a & ~b & ~c & d) | 
             (a & b & ~c & d) | 
             (a & b & c & d);

// Alternatively, after careful analysis and simplification:
assign out = (a & ~b & ~c) | (a & d) | (b & c & d) | (~a & ~b & c & ~d) | (~a & b & c & d);

endmodule