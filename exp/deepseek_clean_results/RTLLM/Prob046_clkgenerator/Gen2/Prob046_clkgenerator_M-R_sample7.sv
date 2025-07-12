module clkgenerator #(parameter PERIOD_NS = 10) (
    output reg clk
);

    initial begin
        clk = 0;
        forever #(PERIOD_NS/2) clk = ~clk;
    end

endmodule