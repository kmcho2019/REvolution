/**
 * freq_div.v
 *
 * Frequency Divider Module - Single Counter Unified Approach
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
 * Implementation:
 *   - One 7-bit counter counts from 0 to 99, then resets.
 *   - CLK_50 derived from MSB of counter (toggles every 50 input clocks).
 *   - CLK_10 toggles on counter values where lower 4 bits are 4 (every 5 cycles).
 *   - CLK_1 toggles when counter == 49.
 *   - All clocks updated synchronously inside one always block with asynchronous reset.
 */

module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [6:0] counter; // Counts 0 to 99

    // We need to toggle CLK_10 and CLK_1 at specific counts
    reg toggle_clk_10;
    reg toggle_clk_1;

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            counter <= 7'd0;
            CLK_50  <= 1'b0;
            CLK_10  <= 1'b0;
            CLK_1   <= 1'b0;
        end else begin
            // Increment counter or reset at 99
            if (counter == 7'd99) begin
                counter <= 7'd0;
            end else begin
                counter <= counter + 1'b1;
            end

            // CLK_50 derived from MSB of counter: toggles every 50 cycles (count from 0..99)
            // MSB of 7-bit counter: bit 6 (counts 0..99)
            // 0..49 => MSB=0, 50..99 => MSB=1
            CLK_50 <= counter[6];

            // Toggle CLK_10 at count values 4, 14, 24, ..., 94 (every 10 cycles toggle halfway at count%10=4)
            // So check lower 4 bits == 4 (4,14,24,...94)
            if ((counter[3:0] == 4'd4)) begin
                CLK_10 <= ~CLK_10;
            end

            // Toggle CLK_1 at count == 49 (half of 100 cycles)
            if (counter == 7'd49) begin
                CLK_1 <= ~CLK_1;
            end
        end
    end

endmodule