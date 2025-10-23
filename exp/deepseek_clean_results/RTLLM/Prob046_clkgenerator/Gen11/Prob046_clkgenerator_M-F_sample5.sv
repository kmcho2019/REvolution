`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10  // Clock period in nanoseconds
) (
    output reg clk         // Generated clock output
);

    // Calculate half period for toggle timing
    localparam HALF_PERIOD = PERIOD / 2;

    // Combined initialization and clock generation
    always begin
        clk = 0;
        forever begin
            #HALF_PERIOD clk = ~clk;
        end
    end

endmodule