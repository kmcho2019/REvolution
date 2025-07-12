module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Novel approach using basic logical operations to directly implement the conditions
// under which q is 1, based on the observation of the simulation waveform.
assign q = ((~a & ~b & ~c & ~d) | 
           (~a & ~b & c & d) | 
           (~a & b & ~c & d) | 
           (~a & b & c & ~d) | 
           (a & ~b & ~c & d) | 
           (a & ~b & c & ~d) | 
           (a & b & ~c & ~d) | 
           (a & b & c & d));

endmodule