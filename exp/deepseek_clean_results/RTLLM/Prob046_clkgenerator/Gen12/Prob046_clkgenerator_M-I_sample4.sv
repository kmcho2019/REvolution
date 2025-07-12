`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10  // Clock period in nanoseconds (must be even)
) (
    output reg clk = 0,    // Generated clock output (initialized to 0)
    input wire enable,     // Clock enable signal (active high)
    input wire reset_n     // Active-low reset
);

    // Validate parameter (PERIOD must be even for 50% duty cycle)
    initial begin
        if (PERIOD % 2 != 0) begin
            $error("PERIOD parameter must be even for 50%% duty cycle");
            $finish;
        end
    end

    // Clock generation process
    always begin
        // Wait for reset deassertion if active
        if (!reset_n) begin
            clk <= 0;
            @(posedge reset_n);  // Wait for reset to deassert
        end

        // Clock generation when enabled
        if (enable) begin
            #(PERIOD/2) clk <= ~clk;
        end
        // Hold low when disabled
        else begin
            clk <= 0;
            @(posedge enable);  // Wait for enable
        end
    end

endmodule