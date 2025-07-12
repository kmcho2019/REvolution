`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10  // Clock period in ns
) (
    output reg clk = 0,
    input reset = 0
);

    // Calculate half period in simulation time units
    localparam HALF_PERIOD = PERIOD / 2;
    
    // Parameter validation
    initial begin
        assert (PERIOD > 0) else $error("PERIOD must be positive");
        if (PERIOD % 2 != 0) 
            $warning("Odd PERIOD may cause duty cycle inaccuracy");
    end

    always begin
        // Wait for half period
        #HALF_PERIOD;
        
        // Toggle clock with non-blocking assignment
        if (!reset) begin
            clk <= ~clk;
        end
        else begin
            clk <= 0;
        end
    end

endmodule