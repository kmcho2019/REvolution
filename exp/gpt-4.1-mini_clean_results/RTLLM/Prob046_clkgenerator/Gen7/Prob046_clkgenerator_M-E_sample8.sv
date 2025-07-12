`timescale 1ns / 1ps

module clkgenerator #(
    parameter PERIOD = 10
)(
    input wire clk_in,       // Input clock (must be at least twice as fast as output clk frequency)
    input wire reset_n,      // Active-low synchronous reset
    output reg clk           // Generated clock output
);

localparam HALF_PERIOD = PERIOD / 2;
localparam CNT_WIDTH = $clog2(HALF_PERIOD == 0 ? 1 : HALF_PERIOD);

reg [CNT_WIDTH-1:0] counter;

always @(posedge clk_in) begin
    if (!reset_n) begin
        counter <= 0;
        clk <= 0;
    end else begin
        if (counter == (HALF_PERIOD - 1)) begin
            counter <= 0;
            clk <= ~clk;
        end else begin
            counter <= counter + 1;
        end
    end
end

endmodule