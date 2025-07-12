`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10  // Clock period in ns
) (
    output reg clk         // Output clock signal
);

    // Calculate half period for clock toggling
    localparam HALF_PERIOD = PERIOD / 2;

    initial begin
        clk = 0;  // Initialize clock to 0
        forever begin
            #HALF_PERIOD clk = ~clk;  // Toggle clock every half period
        end
    end

endmodule