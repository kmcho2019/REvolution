module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk = 1'b0
);

always #((PERIOD / 2)) clk = ~clk;

endmodule