/**
 * freq_div.v
 * 
 * Frequency Divider Module (Refactored)
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
 * This refactored version uses a single synchronous process with counters that count up to division values. 
 * The outputs are derived from counter states, producing the required divided clocks without explicit toggle logic.
 */

module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Division counts (full cycle counts)
    localparam DIV_2   = 2;    // divide by 2 (CLK_50)
    localparam DIV_10  = 10;   // divide by 10 (CLK_10)
    localparam DIV_100 = 100;  // divide by 100 (CLK_1)

    // Counters
    reg [0:0] cnt_2;          // 1-bit counter for divide by 2
    reg [3:0] cnt_10;         // 4-bit counter for divide by 10
    reg [6:0] cnt_100;        // 7-bit counter for divide by 100

    always @(posedge CLK_in) begin
        if (RST) begin
            cnt_2   <= 0;
            cnt_10  <= 0;
            cnt_100 <= 0;
            CLK_50  <= 0;
            CLK_10  <= 0;
            CLK_1   <= 0;
        end else begin
            // Count for divide by 2
            if (cnt_2 == DIV_2 - 1) begin
                cnt_2 <= 0;
                CLK_50 <= ~CLK_50;
            end else begin
                cnt_2 <= cnt_2 + 1;
            end

            // Count for divide by 10
            if (cnt_10 == DIV_10 - 1) begin
                cnt_10 <= 0;
                CLK_10 <= ~CLK_10;
            end else begin
                cnt_10 <= cnt_10 + 1;
            end

            // Count for divide by 100
            if (cnt_100 == DIV_100 - 1) begin
                cnt_100 <= 0;
                CLK_1 <= ~CLK_1;
            end else begin
                cnt_100 <= cnt_100 + 1;
            end
        end
    end

endmodule