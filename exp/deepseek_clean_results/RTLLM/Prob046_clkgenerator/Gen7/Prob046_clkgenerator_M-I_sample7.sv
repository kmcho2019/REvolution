`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10  // Clock period in ns
) (
    output reg clk = 0,
    input reset = 0
);

    // Calculate half period in simulation time units
    localparam HALF_PERIOD = PERIOD / 2;
    
    // Time counter for clock generation
    integer time_counter = 0;

    always begin
        // Wait for half period
        #HALF_PERIOD;
        
        // Toggle clock if not in reset
        if (!reset) begin
            clk = ~clk;
        end
        else begin
            clk = 0;
        end
    end

    // Parameter validation
    initial begin
        if (PERIOD <= 0) begin
            $error("PERIOD must be positive");
            $finish;
        end
        if (PERIOD % 2 != 0) begin
            $warning("Odd PERIOD may cause duty cycle inaccuracy");
        end
    end

endmodule