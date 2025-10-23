`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10    // Clock period in nanoseconds
) (
    output reg clk = 0       // Generated clock output
);

    // Calculate half period for 50% duty cycle
    localparam HALF_PERIOD = PERIOD / 2;

    // Clock generation loop
    always begin
        #HALF_PERIOD clk = ~clk;  // Toggle clock every half period
    end

    // Initialization
    initial begin
        if (PERIOD < 2) begin
            $display("Error: Period must be >= 2ns");
            $finish;
        end
        $display("Clock generator initialized with period: %0dns", PERIOD);
    end

endmodule