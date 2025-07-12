module clkgenerator #(parameter PERIOD = 10) (
    output wire clk
);

    reg clk_reg = 0;
    
    initial begin
        clk_reg = 0;
    end
    
    assign #(PERIOD/2) clk = clk_reg;
    
    always #(PERIOD/2) clk_reg = ~clk_reg;

endmodule