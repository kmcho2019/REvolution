`timescale 1ns / 1ps

module clkgenerator #(parameter PERIOD = 10) (
    output reg clk
);

localparam HALF_PERIOD = PERIOD / 2;

// Initialize clock to 0 at time 0
initial begin
    clk = 1'b0;
end

// Toggle clock every half period indefinitely
always begin
    #(HALF_PERIOD) clk = ~clk;
end

endmodule