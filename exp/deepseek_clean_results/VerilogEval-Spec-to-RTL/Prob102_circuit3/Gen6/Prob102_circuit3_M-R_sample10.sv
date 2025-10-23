module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Refactored implementation with intermediate signals
    wire ab_or;
    wire cd_or;
    
    assign ab_or = a | b;
    assign cd_or = c | d;
    assign q = ab_or & cd_or;
endmodule