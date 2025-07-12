`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10,         // Clock period in ns
    parameter DUTY_CYCLE = 50,     // Duty cycle percentage (50 for square wave)
    parameter INITIAL_STATE = 0,   // Initial clock state (0 or 1)
    parameter SIM_DURATION = 1000  // Simulation duration in ns (0 for infinite)
) (
    output reg clk                 // Output clock signal
);

    localparam HIGH_TIME = (PERIOD * DUTY_CYCLE) / 100;
    localparam LOW_TIME = PERIOD - HIGH_TIME;

    initial begin
        // Parameter validation
        if (PERIOD <= 0) begin
            $fatal("Error: PERIOD must be positive (given %0d)", PERIOD);
        end
        if (DUTY_CYCLE <= 0 || DUTY_CYCLE >= 100) begin
            $fatal("Error: DUTY_CYCLE must be between 1-99 (given %0d)", DUTY_CYCLE);
        end
        
        $display("Clock Generator Started:");
        $display("  Period: %0dns, Duty Cycle: %0d%%, Initial State: %0d", 
                 PERIOD, DUTY_CYCLE, INITIAL_STATE);
        
        clk = INITIAL_STATE;
        
        if (SIM_DURATION > 0) begin
            #SIM_DURATION $display("Clock Generator Stopped at %0dns", $time);
            $finish;
        end
        
        forever begin
            #HIGH_TIME clk = ~clk;
            #LOW_TIME clk = ~clk;
        end
    end

endmodule