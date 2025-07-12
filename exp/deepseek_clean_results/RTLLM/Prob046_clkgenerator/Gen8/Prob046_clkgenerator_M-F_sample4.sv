`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10  // Clock period in nanoseconds
) (
    output reg clk          // Generated clock output
);

    // Initialize clock to 0
    initial clk = 0;

    // Clock generation process
    always begin
        #(PERIOD/2) clk = ~clk;
    end

endmodule