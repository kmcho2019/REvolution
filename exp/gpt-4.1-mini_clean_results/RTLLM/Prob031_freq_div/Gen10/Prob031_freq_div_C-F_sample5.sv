/**
 * freq_div.v
 *
 * Frequency Divider Module
 *
 * Inputs:
 *   CLK_in - 100 MHz input clock
 *   RST    - Asynchronous active-high reset
 *
 * Outputs:
 *   CLK_50 - 50 MHz clock output (CLK_in / 2)
 *   CLK_10 - 10 MHz clock output (CLK_in / 10)
 *   CLK_1  -  1 MHz clock output (CLK_in / 100)
 *
 * The module divides the input clock frequency using counters and toggling outputs
 * at specified count thresholds, with separate always blocks for each output clock.
 */

module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Parameterized terminal count values for frequency division
    localparam CNT_10_MAX  = 3'd4;    // Toggle CLK_10 when cnt_10 == 4 (divide by 10)
    localparam CNT_100_MAX = 6'd49;   // Toggle CLK_1 when cnt_100 == 49 (divide by 100)

    // Counters for CLK_10 and CLK_1 generation
    reg [2:0]  cnt_10;
    reg [5:0]  cnt_100;

    // CLK_50 generation: divide by 2 (toggle every clock)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // CLK_10 generation: divide by 10 (toggle every 5 CLK_in cycles)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_10 <= 3'd0;
            CLK_10 <= 1'b0;
        end else if (cnt_10 == CNT_10_MAX) begin
            cnt_10 <= 3'd0;
            CLK_10 <= ~CLK_10;
        end else begin
            cnt_10 <= cnt_10 + 1'b1;
        end
    end

    // CLK_1 generation: divide by 100 (toggle every 50 CLK_in cycles)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_100 <= 6'd0;
            CLK_1 <= 1'b0;
        end else if (cnt_100 == CNT_100_MAX) begin
            cnt_100 <= 6'd0;
            CLK_1 <= ~CLK_1;
        end else begin
            cnt_100 <= cnt_100 + 1'b1;
        end
    end

endmodule