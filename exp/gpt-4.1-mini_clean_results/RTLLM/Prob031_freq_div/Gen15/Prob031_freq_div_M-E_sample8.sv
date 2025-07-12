/**
 * freq_div.v
 *
 * Frequency Divider Module - Single Counter Shared for Multiple Outputs
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
 *   - A single 7-bit counter counts 0 to 99 (100 cycles).
 *   - CLK_50 toggles every 1 input cycle (on every odd counter value).
 *   - CLK_10 toggles at counts 4 and 9 to generate 10 MHz (50% duty cycle).
 *   - CLK_1 toggles at count 49 to generate 1 MHz (50% duty cycle).
 *   - All outputs updated synchronously with the input clock.
 *   - Asynchronous reset clears counter and outputs.
 */

module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [6:0] counter; // Counts from 0 to 99

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            counter <= 7'd0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
        end else begin
            // Increment counter with wrap-around
            if (counter == 7'd99)
                counter <= 7'd0;
            else
                counter <= counter + 7'd1;

            // CLK_50 toggles every clock cycle -> dividing by 2
            // We can derive CLK_50 from LSB of counter, but to meet toggle on posedge,
            // we toggle CLK_50 when LSB of counter changes from 0 to 1.
            // Here, toggling CLK_50 on every odd counter value:
            if (counter[0] == 1'b1)
                CLK_50 <= 1'b1;
            else
                CLK_50 <= 1'b0;

            // CLK_10 toggles at counts 4 and 9, generating a 10 MHz clock (divide by 10)
            // We toggle CLK_10 on these counts to get a 50% duty cycle output
            if (counter == 7'd4)
                CLK_10 <= 1'b1;
            else if (counter == 7'd9)
                CLK_10 <= 1'b0;

            // CLK_1 toggles at count 49, divide by 100
            // Toggle CLK_1 at 49, reset at 99 for 50% duty cycle
            if (counter == 7'd49)
                CLK_1 <= ~CLK_1;
        end
    end

endmodule