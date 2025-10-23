module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

localparam HALF_PERIOD = PERIOD / 2;

always #HALF_PERIOD clk = ~clk;

endmodule