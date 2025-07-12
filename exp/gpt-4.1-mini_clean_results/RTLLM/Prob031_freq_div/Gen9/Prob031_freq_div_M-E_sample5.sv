/**
 * freq_div.v
 * 
 * Frequency Divider Module using Single Counter Approach
 * 
 * Input:
 *   CLK_in - 100 MHz clock input
 *   RST    - Synchronous active-high reset
 * 
 * Outputs:
 *   CLK_50 - 50 MHz clock output (CLK_in divided by 2)
 *   CLK_10 - 10 MHz clock output (CLK_in divided by 10)
 *   CLK_1  -  1 MHz clock output (CLK_in divided by 100)
 * 
 * The module uses a single 7-bit counter cycling from 0 to 99. 
 * Each output clock toggles when the counter reaches half the division period minus one,
 * producing a 50% duty cycle for each output frequency.
 */

module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Parameters defining half-period counts for toggling output clocks
    localparam HALF_50 = 1 - 1;    // (2/2) - 1 = 0
    localparam HALF_10 = 5 - 1;    // (10/2) -1 = 4
    localparam HALF_1  = 50 - 1;   // (100/2)-1 = 49
    localparam COUNTER_MAX = 100 - 1; // 0 to 99

    // 7-bit counter sufficient to count up to 99
    reg [6:0] counter;

    always @(posedge CLK_in) begin
        if (RST) begin
            counter <= 7'd0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
        end else begin
            // Increment counter with wrap-around
            if (counter == COUNTER_MAX)
                counter <= 7'd0;
            else
                counter <= counter + 7'd1;

            // Toggle CLK_50 when counter reaches HALF_50 (0)
            if (counter == HALF_50)
                CLK_50 <= ~CLK_50;

            // Toggle CLK_10 when counter reaches HALF_10 (4)
            if (counter == HALF_10)
                CLK_10 <= ~CLK_10;

            // Toggle CLK_1 when counter reaches HALF_1 (49)
            if (counter == HALF_1)
                CLK_1 <= ~CLK_1;
        end
    end

endmodule