`timescale 1ns/1ps

module clkgenerator #(parameter PERIOD = 10) (
    output reg clk = 0
);

    // Toggle clk every half period
    always begin
        #(PERIOD/2) clk = ~clk;
    end

endmodule