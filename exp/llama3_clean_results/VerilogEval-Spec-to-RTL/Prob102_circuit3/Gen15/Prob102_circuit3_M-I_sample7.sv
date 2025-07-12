// Directly implement the logic for computing q in the TopModule
module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    
    // Compute the output q directly
    assign q = (a | b) & (c | d);
    
endmodule