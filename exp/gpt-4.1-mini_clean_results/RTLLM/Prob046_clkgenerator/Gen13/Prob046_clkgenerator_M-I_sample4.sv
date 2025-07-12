`timescale 1ns / 1ps

module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);

    // Half period delay for toggling the clock
    localparam integer HALF_PERIOD = PERIOD / 2;

    // Compile-time check: PERIOD must be even for 50% duty cycle
    initial begin
        if (PERIOD % 2 != 0) begin
            $error("Parameter PERIOD must be even to produce a 50%% duty cycle. Current value: %0d", PERIOD);
            $finish;
        end
    end

    // Initialize clock to 0
    initial begin
        clk = 1'b0;
    end

    // Toggle clock every half period to create a square wave
    always begin
        #(HALF_PERIOD) clk = ~clk;
    end

endmodule