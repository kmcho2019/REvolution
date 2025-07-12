`timescale 1ns/1ps

module clkgenerator #(parameter integer PERIOD = 10) (
    output reg clk
);

    initial begin
        if (PERIOD <= 0) begin
            $display("Error: PERIOD parameter must be positive. Given: %0d", PERIOD);
            $finish;
        end
        clk = 0;
        forever #(PERIOD/2) clk = ~clk;
    end

endmodule