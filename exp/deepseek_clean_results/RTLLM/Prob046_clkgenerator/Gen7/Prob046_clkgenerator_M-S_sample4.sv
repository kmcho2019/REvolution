`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10  // Clock period in ns
) (
    output reg clk         // Output clock signal
);

    initial begin
        if (PERIOD <= 0) begin
            $fatal("PERIOD must be positive");
        end
        clk = 0;
        forever #(PERIOD/2) clk = ~clk;
    end

endmodule