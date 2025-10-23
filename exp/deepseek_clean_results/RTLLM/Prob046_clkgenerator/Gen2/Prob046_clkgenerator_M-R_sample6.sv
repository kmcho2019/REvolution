`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10,         // Total clock period in ns
    parameter DUTY_CYCLE = 50      // Duty cycle percentage
) (
    input wire reset_n,            // Active-low reset
    input wire enable,             // Clock enable control
    output wire clk                // Generated clock signal
);

    realtime counter;
    realtime high_time = (PERIOD * DUTY_CYCLE) / 100.0;
    realtime low_time = PERIOD - high_time;

    // Update simulation time counter
    always #1 counter = $realtime;

    // Clock generation using continuous assignment
    assign clk = (!reset_n) ? 1'b0 : 
                 (!enable) ? 1'b0 :
                 ((counter % PERIOD) < high_time) ? 1'b1 : 1'b0;

    // Initialize counter
    initial begin
        counter = 0;
    end

endmodule