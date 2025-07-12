`timescale 1ns / 1ps

module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);

// Half period delay for toggling the clock
localparam integer HALF_PERIOD = PERIOD / 2;

initial begin
    clk = 1'b0;  // Initialize clock to 0
end

// Toggle clock every half period to create square wave
always begin
    #(HALF_PERIOD) clk = ~clk;
end

endmodule