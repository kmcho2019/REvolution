`timescale 1ns / 1ps

module clkgenerator #(parameter PERIOD = 10)(
    output reg clk
);

localparam HALF_PERIOD = PERIOD / 2;

initial begin
    clk = 0;
    forever #(HALF_PERIOD) clk = ~clk;
end

endmodule