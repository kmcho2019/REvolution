`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10  // Clock period in ns
) (
    output reg clk = 0
);

    reg [31:0] counter = 0;
    
    // Parameter validation
    initial begin
        if (PERIOD <= 0) $fatal("PERIOD must be positive");
        if (PERIOD % 2 != 0) $warning("PERIOD should be even for 50% duty cycle");
    end

    // Counter-based clock generation
    always @(*) begin
        if (counter >= PERIOD) begin
            counter = 0;
        end
    end

    // Clock toggling at half period
    always @(counter) begin
        if (counter == PERIOD/2) begin
            clk = ~clk;
        end
    end

    // Continuous counter increment
    always begin
        #1 counter = counter + 1;
    end

endmodule