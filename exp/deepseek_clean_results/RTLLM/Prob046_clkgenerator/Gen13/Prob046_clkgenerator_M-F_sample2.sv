`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10  // Clock period in nanoseconds
) (
    output reg clk = 0    // Generated clock output
);

    localparam HALF_PERIOD = PERIOD / 2;
    reg [31:0] counter = 0;

    always begin
        #HALF_PERIOD clk = ~clk;
    end

    initial begin
        clk = 0;
    end

endmodule