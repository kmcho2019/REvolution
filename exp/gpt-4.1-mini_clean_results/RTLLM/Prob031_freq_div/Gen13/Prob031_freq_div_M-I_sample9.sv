/**
 * freq_div.v
 *
 * Optimized Frequency Divider Module using a single counter and synchronous toggling.
 *
 * Inputs:
 *   CLK_in - 100 MHz input clock
 *   RST    - Asynchronous active-high reset
 *
 * Outputs:
 *   CLK_50 - 50 MHz clock output (CLK_in / 2)
 *   CLK_10 - 10 MHz clock output (CLK_in / 10)
 *   CLK_1  - 1 MHz clock output (CLK_in / 100)
 *
 * Implementation:
 *   - Single 7-bit counter counts from 0 to 99 and wraps around.
 *   - CLK_50 toggles every input clock cycle (divide by 2).
 *   - CLK_10 toggles when counter == 4, 14, 24, ..., 94 (every 5 input clocks).
 *   - CLK_1 toggles when counter == 49 (half period of 100 cycles).
 *   - Asynchronous reset active high.
 *   - Non-blocking assignments for synchronous logic.
 */

module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // 7-bit counter to count from 0 to 99
    reg [6:0] cnt;

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt     <= 7'd0;
            CLK_50  <= 1'b0;
            CLK_10  <= 1'b0;
            CLK_1   <= 1'b0;
        end else begin
            // Increment counter and wrap at 99
            if (cnt == 7'd99)
                cnt <= 7'd0;
            else
                cnt <= cnt + 7'd1;

            // Toggle CLK_50 every clock (divide by 2)
            CLK_50 <= ~CLK_50;

            // Toggle CLK_10 every 5 input clocks at count 4,14,24,...
            if (cnt % 7'd10 == 7'd4)
                CLK_10 <= ~CLK_10;

            // Toggle CLK_1 at count 49 (half period)
            if (cnt == 7'd49)
                CLK_1 <= ~CLK_1;
        end
    end

endmodule