`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10,          // Clock period in ns
    parameter DUTY_CYCLE = 50       // Duty cycle percentage (0-100)
) (
    output reg clk,
    input wire enable,              // Clock enable (active high)
    input wire reset_n              // Active-low reset
);

    // Calculate high and low times based on duty cycle
    localparam HIGH_TIME = (PERIOD * DUTY_CYCLE) / 100;
    localparam LOW_TIME = PERIOD - HIGH_TIME;

    // Parameter validation
    initial begin
        if (PERIOD <= 0) $error("PERIOD must be positive");
        if (DUTY_CYCLE < 0 || DUTY_CYCLE > 100) $error("DUTY_CYCLE must be 0-100");
    end

    // Clock generation process
    always begin
        if (!reset_n) begin
            clk = 0;
            @(posedge reset_n);  // Wait for reset to deassert
        end
        
        if (enable) begin
            clk = 1'b1;
            #(HIGH_TIME);
            clk = 1'b0;
            #(LOW_TIME);
        end else begin
            clk = 1'b0;
            @(posedge enable);  // Wait for enable
        end
    end

endmodule