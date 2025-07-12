`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10 // Period in nanoseconds
) (
    output reg clk
);

// Initialize clock to 0
initial begin
    clk = 0;
end

// Toggle clock every half period
always begin
    #(PERIOD/2) clk = ~clk;
end

endmodule