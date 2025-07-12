`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10  // Clock period in ns
) (
    input wire clk_in,     // Input clock (higher frequency)
    input wire reset_n,    // Active-low reset
    output reg clk_out     // Generated clock output
);

    // Calculate required counter value for desired period
    localparam HALF_PERIOD = PERIOD/2;
    localparam COUNTER_MAX = HALF_PERIOD * 2 - 1;
    
    reg [31:0] counter;

    initial begin
        if (PERIOD <= 0) $fatal("PERIOD must be positive");
    end

    always @(posedge clk_in or negedge reset_n) begin
        if (!reset_n) begin
            counter <= 0;
            clk_out <= 0;
        end
        else begin
            if (counter == COUNTER_MAX) begin
                counter <= 0;
                clk_out <= ~clk_out;
            end
            else begin
                counter <= counter + 1;
            end
        end
    end

endmodule