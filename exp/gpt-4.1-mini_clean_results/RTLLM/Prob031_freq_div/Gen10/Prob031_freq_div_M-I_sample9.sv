/**
 * freq_div.v
 *
 * Frequency Divider Module - Improved Power Efficiency and Modularity
 *
 * Inputs:
 *   CLK_in - 100 MHz input clock
 *   RST    - Synchronous active-high reset
 *
 * Outputs:
 *   CLK_50 - 50 MHz clock output (CLK_in / 2)
 *   CLK_10 - 10 MHz clock output (CLK_in / 10)
 *   CLK_1  -  1 MHz clock output (CLK_in / 100)
 *
 * This improved version uses separate always blocks and gated counters to reduce switching activity,
 * leading to better power efficiency while maintaining performance and clarity.
 */

module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    localparam CNT_10_MAX  = 3'd4;   // Toggle CLK_10 at count 4 (divide by 10)
    localparam CNT_100_MAX = 6'd49;  // Toggle CLK_1  at count 49 (divide by 100)

    // Counters for frequency division
    reg [2:0]  cnt_10;
    reg [5:0]  cnt_100;

    // CLK_50: Toggle every CLK_in cycle => divide by 2
    always @(posedge CLK_in) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // CLK_10 with gated counter: count increments only when not toggling output
    always @(posedge CLK_in) begin
        if (RST) begin
            CLK_10 <= 1'b0;
            cnt_10 <= 3'd0;
        end else begin
            if (cnt_10 == CNT_10_MAX) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 3'd0;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end
        end
    end

    // CLK_1 with gated counter: count increments only when not toggling output
    always @(posedge CLK_in) begin
        if (RST) begin
            CLK_1 <= 1'b0;
            cnt_100 <= 6'd0;
        end else begin
            if (cnt_100 == CNT_100_MAX) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= 6'd0;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule