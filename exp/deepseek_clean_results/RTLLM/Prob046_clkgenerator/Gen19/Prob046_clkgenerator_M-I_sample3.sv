`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10    // Clock period in nanoseconds
) (
    input wire rst_n,        // Active-low reset
    output reg clk           // Generated clock output
);

    localparam HALF_PERIOD = PERIOD / 2;
    reg [$clog2(HALF_PERIOD)-1:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            clk <= 0;
        end else begin
            if (counter == HALF_PERIOD-1) begin
                counter <= 0;
                clk <= ~clk;
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule