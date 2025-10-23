module clkgenerator #(
    parameter PERIOD = 10
)(
    output clk
);

    reg clk_reg = 1'b0;
    
    always begin
        #(PERIOD/2) clk_reg = ~clk_reg;
    end
    
    assign clk = clk_reg;

endmodule