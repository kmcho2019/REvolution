`timescale 1ns/1ps

module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);

    // Check that PERIOD is even at elaboration time (only for simulation warning)
    initial begin
        if (PERIOD % 2 != 0) begin
            $display("Warning: PERIOD parameter should be even to ensure integer half period.");
        end
    end

    // Internal base clock toggling every 1 time unit
    reg base_clk = 0;
    always #1 base_clk = ~base_clk;

    // Counter counts up to half the PERIOD (integer division)
    localparam integer HALF_PERIOD = PERIOD / 2;
    integer count = 0;

    initial clk = 0;

    always @(posedge base_clk) begin
        if (count == HALF_PERIOD - 1) begin
            clk <= ~clk;
            count <= 0;
        end else begin
            count <= count + 1;
        end
    end

endmodule