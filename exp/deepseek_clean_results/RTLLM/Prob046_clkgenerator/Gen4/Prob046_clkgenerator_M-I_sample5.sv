`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10  // Clock period in ns
) (
    output reg clk         // Generated clock signal
);

    // Calculate half period (toggle point)
    localparam HALF_PERIOD = PERIOD / 2;
    reg [31:0] counter;

    // Clock generation
    initial begin
        clk = 0;
        counter = 0;
    end

    always #HALF_PERIOD clk = ~clk;

endmodule