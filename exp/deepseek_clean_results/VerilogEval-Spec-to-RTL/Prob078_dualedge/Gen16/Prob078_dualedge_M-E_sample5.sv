module TopModule (
    input clk,
    input d,
    output q
);

    // Asymmetric latch implementation
    reg latch1, latch2;
    
    // Latch1 transparent when clk is high
    always @(clk or d)
        if (clk) latch1 = d;
    
    // Latch2 transparent when clk is low
    always @(clk or d)
        if (!clk) latch2 = d;
    
    // Combine latch outputs
    assign q = latch1 | latch2;

endmodule