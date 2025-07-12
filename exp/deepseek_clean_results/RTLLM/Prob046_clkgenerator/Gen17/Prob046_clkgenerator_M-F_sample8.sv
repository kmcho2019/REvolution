`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10    // Clock period in nanoseconds
) (
    output reg clk           // Generated clock
);

    // Internal counter for timing control
    reg [31:0] counter;
    
    // Calculate half period point (rounding down for odd periods)
    localparam HALF_PERIOD = PERIOD / 2;
    
    // Clock generation process
    always begin
        // Initialize clock and counter
        clk = 0;
        counter = 0;
        
        // Main clock generation loop
        forever begin
            // Wait for half period
            #HALF_PERIOD;
            clk = ~clk;
            
            // Wait for remaining half period
            #(PERIOD - HALF_PERIOD);
            clk = ~clk;
        end
    end

endmodule