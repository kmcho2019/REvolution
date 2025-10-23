module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Intermediate signals for clearer logic breakdown
    wire ab_or;  // OR of a and b
    wire cd_or;  // OR of c and d
    
    // First level OR operations
    assign ab_or = a | b;
    assign cd_or = c | d;
    
    // Final AND operation
    assign q = ab_or & cd_or;
endmodule