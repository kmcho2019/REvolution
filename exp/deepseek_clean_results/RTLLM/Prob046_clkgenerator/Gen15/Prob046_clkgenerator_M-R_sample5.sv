`timescale 1ns/1ns

module clkgenerator #(
    parameter PERIOD = 10
) (
    output wire clk
);

reg [31:0] counter = 0;
wire clk_reg;

always #1 counter = (counter >= PERIOD-1) ? 0 : counter + 1;

assign clk_reg = (counter < PERIOD/2) ? 1'b0 : 1'b1;
assign clk = clk_reg;

endmodule