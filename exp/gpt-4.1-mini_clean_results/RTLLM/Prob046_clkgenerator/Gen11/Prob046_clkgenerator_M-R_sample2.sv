`timescale 1ns/1ps

module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);

    localparam integer HALF_PERIOD = PERIOD / 2;

    reg [$clog2(PERIOD):0] counter = 0; // Counter width enough to hold PERIOD

    initial begin
        clk = 1'b0;
        counter = 0;
    end

    always @(*) begin
        // No combinational logic for clk, controlled inside always_ff below
    end

    always @(posedge clk or posedge clk) begin
        // dummy to avoid synthesis warning
    end

    always begin
        // Infinite loop without delay not synthesizable - avoid
        // We use an always block with #1 delay to increment counter
    end

    // Use an always block with delay to increment counter every 1 time unit
    // and toggle clk every HALF_PERIOD cycles.
    // This is a workaround to avoid initial block with forever and delays
    // but still use time-based toggling.

    always begin
        #(1);
        counter = (counter + 1) % PERIOD;
        if (counter == 0)
            clk = ~clk;
    end

endmodule