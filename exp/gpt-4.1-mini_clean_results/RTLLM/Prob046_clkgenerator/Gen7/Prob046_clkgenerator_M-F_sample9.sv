`timescale 1ns / 1ps

module clkgenerator #(parameter PERIOD = 10) (
    input  wire clk_in,
    output reg  clk
);

localparam HALF_PERIOD = PERIOD / 2;
localparam COUNTER_WIDTH = $clog2(HALF_PERIOD);

reg [COUNTER_WIDTH-1:0] count = 0;

always @(posedge clk_in) begin
    if (count == HALF_PERIOD - 1) begin
        count <= 0;
        clk <= ~clk;
    end else begin
        count <= count + 1;
    end
end

initial begin
    clk = 0;
end

endmodule