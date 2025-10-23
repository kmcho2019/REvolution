`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10  // Period in input clock cycles, must be even
)(
    input  wire clk_in,    // Reference input clock
    output reg  clk = 0    // Generated clock output
);

    localparam HALF_PERIOD = PERIOD / 2;

    reg [$clog2(PERIOD):0] counter = 0;

    always @(posedge clk_in) begin
        if (counter == HALF_PERIOD - 1) begin
            clk <= ~clk;
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end

endmodule