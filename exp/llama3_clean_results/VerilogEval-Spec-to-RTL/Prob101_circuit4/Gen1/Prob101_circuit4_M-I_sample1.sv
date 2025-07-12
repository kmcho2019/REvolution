module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // Not used in the current implementation
    output q
);
    
    // The logic remains the same as it correctly implements the required behavior
    assign q = ~a || b || c;
    
endmodule