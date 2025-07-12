module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Implementing the circuit using AND and OR gates
// The idea is to create a sum of products that represents the conditions under which q is true
assign q = (~a & ~b & ~c & ~d) | 
           (~a & ~b & ~c & d) | 
           (~a & ~b & c & ~d) | 
           (~a & b & ~c & ~d) | 
           (~a & b & ~c & d) | 
           (~a & b & c & ~d) | 
           (a & ~b & ~c & ~d) | 
           (a & ~b & ~c & d) | 
           (a & ~b & c & ~d) | 
           (a & b & ~c & ~d);

endmodule