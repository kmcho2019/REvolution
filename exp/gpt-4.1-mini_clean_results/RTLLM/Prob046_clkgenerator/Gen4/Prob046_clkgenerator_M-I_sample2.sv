module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);

    // Use real number division to get precise half period delay
    localparam real HALF_PERIOD = PERIOD / 2.0;

    initial begin
        clk = 0;
        forever #(HALF_PERIOD) clk = ~clk;
    end

endmodule