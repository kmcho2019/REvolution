module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);
    // Calculate half period as real to avoid truncation issues
    localparam real half_period = PERIOD / 2.0;

    initial begin
        clk = 1'b0;
        forever begin
            #(half_period) clk = ~clk;
        end
    end
endmodule