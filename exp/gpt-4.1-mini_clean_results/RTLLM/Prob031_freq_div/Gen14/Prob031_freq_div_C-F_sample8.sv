/**
 * freq_div.v
 *
 * Frequency Divider Module - Unified Counter with Multiple Clock Outputs
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
 *   - CLK_50 toggles every clock cycle (divide by 2) directly.
 *   - Single 7-bit counter counts from 0 to 99 and resets.
 *   - CLK_10 toggles when counter reaches 4, 14, 24, ..., (i.e., half period of 10 cycles).
 *   - CLK_1 toggles when counter reaches 49 (half period of 100 cycles).
 *   - Non-blocking assignments and asynchronous reset.
 */

module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // 7-bit counter counting from 0 to 99
    reg [6:0] cnt;

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt    <= 7'd0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
        end else begin
            // Increment and wrap counter
            if (cnt == 7'd99)
                cnt <= 7'd0;
            else
                cnt <= cnt + 7'd1;

            // CLK_50 toggles every clock cycle (divide by 2)
            CLK_50 <= ~CLK_50;

            // CLK_10 toggles at counter == 4, 14, 24, ..., i.e. every 10 cycles at count == 4 + 10*n
            // Implement by toggling when (cnt % 10) == 4
            if (cnt % 10 == 7'd4)
                CLK_10 <= ~CLK_10;

            // CLK_1 toggles at counter == 49 (half period of 100 cycles)
            if (cnt == 7'd49)
                CLK_1 <= ~CLK_1;
        end
    end

endmodule