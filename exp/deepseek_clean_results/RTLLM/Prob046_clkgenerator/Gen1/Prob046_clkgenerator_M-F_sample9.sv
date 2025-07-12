module clkgenerator #(
    parameter PERIOD = 10,       // Total clock period in time units
    parameter INITIAL_STATE = 0  // Initial clock state (0 or 1)
) (
    output reg clk
);

    initial begin
        clk = INITIAL_STATE;
        forever #(PERIOD/2) clk = ~clk;
    end

endmodule