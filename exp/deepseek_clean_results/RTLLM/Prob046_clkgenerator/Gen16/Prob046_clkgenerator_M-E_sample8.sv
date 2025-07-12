`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10    // Clock period in nanoseconds
) (
    output reg clk = 0       // Generated clock (initialized to 0)
);

    // Internal counter for precise timing
    reg [31:0] counter = 0;
    
    // Calculate half period point (rounding down for odd periods)
    localparam HALF_PERIOD = PERIOD / 2;
    
    always @(*) begin
        // Toggle clock when counter crosses half-period threshold
        if (counter >= HALF_PERIOD) begin
            clk = 1;
        end else begin
            clk = 0;
        end
    end
    
    // Counter control process
    always begin
        #1;  // Minimum time precision
        counter = counter + 1;
        
        // Reset counter after completing full period
        if (counter >= PERIOD) begin
            counter = 0;
        end
    end

    // Initial block for simulation clarity
    initial begin
        $display("Counter-based clock generator started");
        $display("Period = %0d ns (Half period = %0d ns)", PERIOD, HALF_PERIOD);
    end

endmodule