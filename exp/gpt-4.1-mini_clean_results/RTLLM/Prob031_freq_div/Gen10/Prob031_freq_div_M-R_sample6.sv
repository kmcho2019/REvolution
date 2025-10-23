/**
 * freq_div.v
 *
 * Refactored Frequency Divider Module
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
 * The module uses a single 7-bit counter that counts from 0 to 99.
 * CLK_50 toggles every clock cycle (based on LSB of counter).
 * CLK_10 toggles every 5 counts.
 * CLK_1 toggles every 50 counts.
 * Outputs are registered and synchronous to CLK_in with asynchronous reset.
 */

module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [6:0] cnt;  // Counts from 0 to 99

    // Next-state toggle signals for CLK_10 and CLK_1
    reg clk_10_next;
    reg clk_1_next;

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt    <= 7'd0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
        end else begin
            // Counter increments and wraps at 99
            if (cnt == 7'd99)
                cnt <= 7'd0;
            else
                cnt <= cnt + 7'd1;

            // CLK_50 toggles every cycle (divide by 2)
            // Toggle CLK_50 at every increment, so it follows the LSB of cnt
            CLK_50 <= ~CLK_50;

            // CLK_10 toggles every 5 counts (at cnt == 4, 9, 14,...)
            // Because toggling every 5 counts means toggle when lower 3 bits == 4
            // Using count mod 10 == 4, but easier: toggle when cnt%10 ==4
            if (cnt % 10 == 4)
                CLK_10 <= ~CLK_10;

            // CLK_1 toggles every 50 counts (at cnt == 49 and 99)
            if (cnt == 7'd49 || cnt == 7'd99)
                CLK_1 <= ~CLK_1;
        end
    end

endmodule