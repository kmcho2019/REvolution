`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10  // Clock period in nanoseconds
) (
    output reg clk          // Generated clock output
);

    // Clock generation with simple toggle and delay
    initial begin
        clk = 0;  // Initialize clock to 0
        forever begin
            #(PERIOD/2) clk = ~clk;  // Toggle every half period
        end
    end

endmodule