`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10  // Clock period in nanoseconds
) (
    output reg clk = 0     // Generated clock output
);

    reg [31:0] counter = 0;

    always begin
        #(PERIOD/2);       // Wait half period
        clk = ~clk;        // Toggle clock
    end

    initial begin
        clk = 0;           // Initialize clock to 0
    end

endmodule