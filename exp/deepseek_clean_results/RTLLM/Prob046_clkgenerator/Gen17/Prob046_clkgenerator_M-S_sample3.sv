module clkgenerator #(parameter PERIOD = 10)(output reg clk);
    initial forever #(PERIOD/2) clk = ~clk;
endmodule