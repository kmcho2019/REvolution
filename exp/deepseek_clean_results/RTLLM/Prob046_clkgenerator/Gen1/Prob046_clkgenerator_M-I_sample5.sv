`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10,         // Total clock period in ns
    parameter DUTY_CYCLE = 50      // Duty cycle percentage (50 for square wave)
) (
    input wire reset_n,            // Active-low reset
    input wire enable,             // Clock enable control
    output reg clk                 // Generated clock signal
);

    localparam HIGH_TIME = (PERIOD * DUTY_CYCLE) / 100;
    localparam LOW_TIME = PERIOD - HIGH_TIME;

    initial begin
        clk = 1'b0;
    end

    always begin
        if (!reset_n) begin
            clk <= 1'b0;
            #(PERIOD);  // Wait for one full period after reset
        end
        else if (enable) begin
            clk <= 1'b1;
            #(HIGH_TIME);
            clk <= 1'b0;
            #(LOW_TIME);
        end
        else begin
            clk <= 1'b0;
            #(PERIOD);  // Wait while disabled
        end
    end

endmodule