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
 * at specified count thresholds, implemented in a single always block for compactness.
 */

module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Parameterized toggle count thresholds
    localparam CNT_10_MAX  = 3'd4;   // Toggle CLK_10 at count 4 (divide by 10)
    localparam CNT_100_MAX = 6'd49;  // Toggle CLK_1  at count 49 (divide by 100)

    // Counters for frequency division
    reg [2:0]  cnt_10;
    reg [5:0]  cnt_100;

    // All frequency division and reset logic combined in one always block
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50  <= 1'b0;
            CLK_10  <= 1'b0;
            CLK_1   <= 1'b0;
            cnt_10  <= 3'd0;
            cnt_100 <= 6'd0;
        end else begin
            // CLK_50 toggles every clock cycle => divide by 2
            CLK_50 <= ~CLK_50;

            // CLK_10 toggles when cnt_10 reaches CNT_10_MAX (4)
            if (cnt_10 == CNT_10_MAX) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 3'd0;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end

            // CLK_1 toggles when cnt_100 reaches CNT_100_MAX (49)
            if (cnt_100 == CNT_100_MAX) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= 6'd0;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule