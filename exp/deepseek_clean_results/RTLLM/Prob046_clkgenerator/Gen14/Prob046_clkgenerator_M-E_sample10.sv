`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10  // Clock period in nanoseconds
) (
    output reg clk = 0     // Generated clock output
);

    // Calculate half period (round down for odd periods)
    localparam HALF_PERIOD = PERIOD / 2;
    localparam COUNTER_MAX = PERIOD - 1;
    
    // Counter that increments every 1ns (matches timescale)
    reg [31:0] counter = 0;

    always @(*) begin
        // Toggle clock when counter crosses half-period threshold
        if (counter < HALF_PERIOD) begin
            clk = 0;
        end else begin
            clk = 1;
        end
    end

    // Counter update logic
    always begin
        #1;  // Wait 1ns (matches timescale)
        counter = (counter == COUNTER_MAX) ? 0 : counter + 1;
    end

endmodule