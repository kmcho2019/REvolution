module clkgenerator #(
    parameter PERIOD = 10
)(
    output clk
);

    wire clk;
    pullup(clk);  // Initialize to 1 (alternative to initial block)
    
    assign #(PERIOD/2) clk = ~clk;  // Continuous assignment with delay

endmodule