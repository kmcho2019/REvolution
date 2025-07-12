module clkgenerator #(
    parameter integer PERIOD = 10
) (
    output reg clk
);

    localparam integer half_period = PERIOD / 2;

    initial begin
        clk = 0;
        forever begin
            #(half_period) clk = ~clk;
        end
    end

endmodule