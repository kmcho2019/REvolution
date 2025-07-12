`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10  // Clock period in nanoseconds
) (
    output reg clk         // Generated clock output
);

    // Calculate half period for 50% duty cycle
    localparam HALF_PERIOD = PERIOD / 2;

    // Initialize clock
    initial clk = 0;

    // Clock generation - simple periodic toggle
    always begin
        #HALF_PERIOD clk = ~clk;
    end

endmodule