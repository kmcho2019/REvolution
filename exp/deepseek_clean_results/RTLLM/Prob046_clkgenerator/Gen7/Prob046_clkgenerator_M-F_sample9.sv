`timescale 1ns/1ps

module clkgenerator #(parameter PERIOD = 10) (
    input reset,        // Active-high reset
    output reg clk      // Generated clock signal
);

    // Calculate half period for toggle timing
    localparam HALF_PERIOD = PERIOD / 2;

    always begin
        #HALF_PERIOD clk <= ~clk;
    end

    // Reset handling - initialize clock to 0
    always @(posedge reset) begin
        if (reset) begin
            clk <= 1'b0;
        end
    end

endmodule