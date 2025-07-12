`timescale 1ns / 1ps

module clkgenerator #(parameter PERIOD = 10) (
    output reg clk
);

localparam integer HALF_PERIOD = PERIOD / 2;

initial begin
    clk = 0;
end

always begin
    #(HALF_PERIOD) clk = ~clk;
end

endmodule