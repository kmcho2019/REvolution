// Directly implement the logic without separate OR gate modules
module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    
    // Compute the output q using a single logic expression
    assign q = (a | b) & (c | d);
    
endmodule