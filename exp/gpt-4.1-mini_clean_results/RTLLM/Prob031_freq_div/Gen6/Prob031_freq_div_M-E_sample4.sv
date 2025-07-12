/**
 * freq_div.v
 *
 * Frequency Divider Module using single shared counter
 *
 * Input:
 *   CLK_in - 100 MHz clock input
 *   RST    - Asynchronous active-high reset
 *
 * Outputs:
 *   CLK_50 - 50 MHz clock output (divide by 2)
 *   CLK_10 - 10 MHz clock output (divide by 10)
 *   CLK_1  - 1 MHz clock output (divide by 100)
 *
 * This implementation uses one counter counting from 0 to 99.
 * Output clocks toggle when the counter reaches specific counts,
 * creating frequency division with synchronized phases.
 */

module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Counter counts from 0 to 99
    reg [6:0] counter; // 7-bit to count up to 100

    // Asynchronous reset, synchronous counter and outputs update
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            counter <= 7'd0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
        end else begin
            // Increment counter modulo 100
            if (counter == 7'd99)
                counter <= 7'd0;
            else
                counter <= counter + 7'd1;

            // Toggle CLK_50 every 1 input clock cycle (period 2)
            // So toggle at every even count (counter % 2 == 0)
            if (counter[0] == 1'b0)  // Even counts: 0,2,4,...
                CLK_50 <= ~CLK_50;

            // Toggle CLK_10 every 5 input clocks → full period 10 cycles
            // Toggle at counts multiple of 10 (0,10,20,...,90)
            if (counter % 10 == 0)
                CLK_10 <= ~CLK_10;

            // Toggle CLK_1 every 50 input clocks → full period 100 cycles
            // Toggle at counts 0 and 50
            if (counter == 7'd0 || counter == 7'd50)
                CLK_1 <= ~CLK_1;
        end
    end

endmodule