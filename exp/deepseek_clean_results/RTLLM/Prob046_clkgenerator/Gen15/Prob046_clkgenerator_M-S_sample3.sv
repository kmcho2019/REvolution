module clkgenerator(output reg clk);
    parameter PERIOD = 10;
    initial clk = 0;
    always #(PERIOD/2) clk = ~clk;
endmodule