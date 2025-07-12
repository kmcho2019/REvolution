module clkgenerator #(
    parameter PERIOD = 10
)(
    output clk
);

    reg clk_reg;
    wire #(PERIOD/2) clk_delayed = ~clk_reg;
    
    initial clk_reg = 0;
    assign clk = clk_reg;
    always @(clk_delayed) clk_reg = clk_delayed;

endmodule