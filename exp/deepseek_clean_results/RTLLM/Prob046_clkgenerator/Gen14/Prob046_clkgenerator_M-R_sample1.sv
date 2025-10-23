`timescale 1ns/1ps

/*
 * Refactored Clock Generator Module
 * Uses continuous assignment with time-based toggling
 */
module clkgenerator #(
    parameter PERIOD = 10    // Clock period in ns
) (
    output wire clk          // Generated clock
);

    // Calculate half period
    localparam HALF_PERIOD = PERIOD / 2;
    
    // Internal register for clock state
    reg clk_reg = 0;
    
    // Continuous assignment to output
    assign clk = clk_reg;
    
    // Time-based toggling
    always begin
        #HALF_PERIOD clk_reg = ~clk_reg;
    end

endmodule