`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10  // Clock period in nanoseconds
) (
    output reg clk,        // Generated clock output
    input wire reset_n,    // Active-low reset
    input wire enable      // Clock enable
);

    // Clock generation with reset and enable control
    always begin
        #(PERIOD/2) clk <= ~clk;
    end

    // Reset and initialization logic
    initial begin
        clk = 0;
        if (!reset_n) begin
            clk <= 0;
            wait (reset_n);  // Hold clock low during reset
        end
    end

    // Clock gating with enable
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            clk <= 0;
        end else if (!enable) begin
            clk <= clk;  // Hold current state when disabled
        end
    end

endmodule