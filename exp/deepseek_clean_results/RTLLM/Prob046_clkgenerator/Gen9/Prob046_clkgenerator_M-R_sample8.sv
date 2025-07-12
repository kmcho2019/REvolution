`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10  // Clock period in nanoseconds
) (
    output reg clk          // Generated clock output
);

    // Initialize clock and start generation
    initial begin
        clk = 0;  // Initial state
        forever begin
            #(PERIOD/2) clk = ~clk;  // Toggle every half period
        end
    end

endmodule