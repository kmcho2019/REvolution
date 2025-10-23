`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10  // Clock period in nanoseconds
) (
    output reg clk = 0     // Generated clock output
);

    // Internal counter (width sufficient for PERIOD)
    reg [31:0] counter = 0;
    wire half_period = (PERIOD >> 1);  // Half period value

    always @(counter) begin
        // Toggle clock when counter crosses half period or wraps
        if (counter >= half_period - 1) begin
            clk <= ~clk;
        end
    end

    always @(*) begin
        // Free-running counter with period-based wrap
        if (counter == PERIOD - 1) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end

    initial begin
        clk = 0;           // Initialize clock to 0
        counter = 0;       // Initialize counter
    end

endmodule