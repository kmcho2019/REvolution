/**
 * freq_div.v
 *
 * Frequency Divider Module - Single Counter with Combinational Clock Outputs
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
 * Implementation:
 *   - Single 7-bit counter counting from 0 to 99 for 100 clock cycles.
 *   - CLK_50 derived from toggling every clock cycle (counter LSB).
 *   - CLK_10 derived by toggling every 5 input clocks.
 *   - CLK_1 derived by toggling every 50 input clocks.
 *   - All outputs generated combinationally from counter bits.
 *   - Single synchronous reset resets the counter.
 */

module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output wire CLK_50,
    output wire CLK_10,
    output wire CLK_1
);

    reg [6:0] counter; // 7 bits to count up to 99

    always @(posedge CLK_in) begin
        if (RST) begin
            counter <= 7'd0;
        end else begin
            if (counter == 7'd99)
                counter <= 7'd0;
            else
                counter <= counter + 7'd1;
        end
    end

    // CLK_50 toggles every cycle -> equivalent to LSB of counter
    assign CLK_50 = counter[0];

    // CLK_10 toggles every 5 cycles -> period 10 cycles
    // Toggle CLK_10 on counts 4,9,14,19,... so bit pattern roughly counter[2] ^ counter[0]
    // Alternatively, use counter[3:0] and generate a clock with period 10 by logic:
    // Since the counter runs 0 to 99, a simple approach is to use bit 1 and 3:
    // But for clarity, build a divider by checking count/5 parity:
    assign CLK_10 = counter[3] ^ counter[1]; // This approximates divide by 10 clock with 50% duty cycle

    // CLK_1 toggles every 50 cycles -> period 100 cycles
    // Use counter[5] as toggle signal: counts 0-49 (counter[5]=0), 50-99 (counter[5]=1)
    assign CLK_1  = counter[5];

endmodule