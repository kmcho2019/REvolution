module clkgenerator #(parameter PERIOD = 10) (
    output clk
);

    reg clk_reg = 0;
    wire #(PERIOD/2) delayed_clk;

    assign delayed_clk = ~clk_reg;
    assign clk = clk_reg;
    
    always @(delayed_clk) clk_reg <= delayed_clk;

endmodule