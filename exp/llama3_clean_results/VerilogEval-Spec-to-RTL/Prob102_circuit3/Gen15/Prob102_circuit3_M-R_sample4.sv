// Refactored TopModule with direct implementation of the required logic
module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    
    // Direct implementation of the required logic
    assign q = (a | b) & (c | d);
    
endmodule