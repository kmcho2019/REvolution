`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10    // Clock period in nanoseconds
) (
    output reg clk = 0       // Generated clock output
);

    // Calculate half period
    localparam HALF_PERIOD = PERIOD / 2;
    
    // Main clock generation
    always begin
        #HALF_PERIOD clk = ~clk;
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