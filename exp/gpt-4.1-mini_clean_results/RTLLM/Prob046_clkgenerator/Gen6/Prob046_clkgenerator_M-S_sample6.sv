module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);
    integer half_period;

    initial begin
        clk = 1'b0;
        half_period = PERIOD / 2;
        forever #(half_period) clk = ~clk;
    end
endmodule