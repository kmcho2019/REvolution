// Improved solution with a single module that directly implements the required logic
module TopModuleImproved(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    
    // Direct implementation of the required logic
    assign q = (a | b) & (c | d);
    
endmodule