`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10  // Clock period in nanoseconds (must be even)
) (
    output reg clk = 0,    // Generated clock output
    input wire enable,     // Clock generation enable
    input wire reset_n     // Active-low reset
);

    // Validate parameter
    initial begin
        if (PERIOD % 2 != 0) begin
            $error("PERIOD must be an even number");
            $finish;
        end
    end

    localparam HALF_PERIOD = PERIOD / 2;

    always begin
        if (!reset_n) begin
            clk <= 0;
            #HALF_PERIOD;  // Synchronize reset release
        end
        else if (enable) begin
            #HALF_PERIOD clk <= ~clk;
        end
        else begin
            #HALF_PERIOD;  // Maintain timing even when disabled
        end
    end

endmodule