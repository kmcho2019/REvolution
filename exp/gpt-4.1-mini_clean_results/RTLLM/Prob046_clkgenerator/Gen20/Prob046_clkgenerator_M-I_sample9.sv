`timescale 1ns / 1ps

module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);

    initial begin
        if (PERIOD <= 0) begin
            $display("Warning: PERIOD parameter should be positive. Given: %0d", PERIOD);
        end
        clk = 0;
        forever begin
            #(PERIOD / 2) clk = ~clk;
        end
    end

endmodule