/**
 * freq_div.v
 * 
 * Frequency Divider Module - Refactored Version
 * 
 * Input:
 *   CLK_in - 100 MHz clock input
 *   RST    - Asynchronous active-high reset
 * 
 * Outputs:
 *   CLK_50 - 50 MHz clock output (CLK_in divided by 2)
 *   CLK_10 - 10 MHz clock output (CLK_in divided by 10)
 *   CLK_1  -  1 MHz clock output (CLK_in divided by 100)
 * 
 * This version uses a single always block to handle all counters synchronously,
 * counting up to half the division factor minus one, then toggling the output
 * clock signals to achieve a 50% duty cycle output clocks.
 */

module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Parameters for half-count values for each divider
    localparam HALF_DIV_2   = 1 - 1;   // For divide by 2 => toggle every 1 clock cycle (count 0)
    localparam HALF_DIV_10  = 5 - 1;   // For divide by 10 => toggle every 5 clock cycles (count 4)
    localparam HALF_DIV_100 = 50 - 1;  // For divide by 100 => toggle every 50 clock cycles (count 49)

    // Counters widths derived from max counts
    reg [0:0]  cnt_2;      // 1-bit counter for divide by 2 (0 to 0)
    reg [2:0]  cnt_10;     // 3-bit counter for divide by 10 (0 to 4)
    reg [5:0]  cnt_100;    // 6-bit counter for divide by 100 (0 to 49)

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            // Reset all outputs and counters
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
            cnt_2  <= 1'b0;
            cnt_10 <= 3'd0;
            cnt_100<= 6'd0;
        end else begin
            // CNT_2: Divide by 2
            if (cnt_2 == HALF_DIV_2) begin
                cnt_2 <= 1'b0;
                CLK_50 <= ~CLK_50;
            end else begin
                cnt_2 <= cnt_2 + 1'b1;
            end

            // CNT_10: Divide by 10
            if (cnt_10 == HALF_DIV_10) begin
                cnt_10 <= 3'd0;
                CLK_10 <= ~CLK_10;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end

            // CNT_100: Divide by 100
            if (cnt_100 == HALF_DIV_100) begin
                cnt_100 <= 6'd0;
                CLK_1 <= ~CLK_1;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule