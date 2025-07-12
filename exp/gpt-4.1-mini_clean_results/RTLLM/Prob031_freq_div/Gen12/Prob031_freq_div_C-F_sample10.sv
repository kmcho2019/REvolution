/**
 * freq_div.v
 *
 * Frequency Divider Module - Fused Modular and Consolidated Implementation
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
 *   - CLK_50 toggled on every rising edge of CLK_in or reset in a dedicated always block.
 *   - CLK_10 and CLK_1 counters and toggles handled in a separate always block.
 *   - All counters sized minimally.
 *   - Asynchronous reset active high.
 */

module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Counter bit widths
    reg [2:0] cnt_10;    // Counts 0 to 4 for divide by 10 (toggle every 5 cycles)
    reg [5:0] cnt_100;   // Counts 0 to 49 for divide by 100 (toggle every 50 cycles)

    // Dedicated always block for CLK_50 to isolate the highest toggle frequency
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // Combined always block for CLK_10 and CLK_1 with their counters and toggling logic
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_10  <= 3'd0;
            CLK_10  <= 1'b0;
            cnt_100 <= 6'd0;
            CLK_1   <= 1'b0;
        end else begin
            // CLK_10 division: toggle every 5 input cycles (0..4)
            if (cnt_10 == 3'd4) begin
                cnt_10 <= 3'd0;
                CLK_10 <= ~CLK_10;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end

            // CLK_1 division: toggle every 50 input cycles (0..49)
            if (cnt_100 == 6'd49) begin
                cnt_100 <= 6'd0;
                CLK_1 <= ~CLK_1;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule