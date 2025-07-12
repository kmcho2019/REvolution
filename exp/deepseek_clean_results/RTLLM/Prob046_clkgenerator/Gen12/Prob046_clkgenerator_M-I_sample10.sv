`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10  // Clock period in nanoseconds
) (
    output reg clk,        // Generated clock output
    input wire enable      // Clock enable control
);

    // Calculate half period for 50% duty cycle
    localparam HALF_PERIOD = PERIOD / 2;

    // Initialize clock
    initial clk = 0;

    // Clock generation
    always begin
        if (enable) begin
            #HALF_PERIOD clk = ~clk;
        end else begin
            clk = 0;
            @(posedge enable);  // Wait for enable to go high
        end
    end

endmodule