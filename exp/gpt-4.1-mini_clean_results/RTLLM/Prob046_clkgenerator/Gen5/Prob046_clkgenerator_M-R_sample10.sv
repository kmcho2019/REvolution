module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);

    // Calculate half period with integer arithmetic, rounding up for odd PERIOD
    localparam integer HALF_PERIOD = (PERIOD + 1) / 2;

    initial begin
        clk = 0;
    end

    always #(HALF_PERIOD) begin
        clk = ~clk;
    end

endmodule