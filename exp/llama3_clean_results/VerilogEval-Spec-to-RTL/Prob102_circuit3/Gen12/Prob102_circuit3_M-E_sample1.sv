module TopModuleNovel(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    
    // Directly implementing the required logic using a single assign statement
    // that combines the OR and AND operations.
    assign q = ((a || b) && (c || d));
    
endmodule