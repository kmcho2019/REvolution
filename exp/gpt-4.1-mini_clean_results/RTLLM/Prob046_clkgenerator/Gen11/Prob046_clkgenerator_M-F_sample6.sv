`timescale 1ns / 1ps

module clkgenerator #(parameter PERIOD = 10) (
    output reg clk
);

localparam HALF_PERIOD = PERIOD / 2;

initial begin
    clk = 1'b0;
end

always begin
    #(HALF_PERIOD) clk = ~clk;
end

endmodule