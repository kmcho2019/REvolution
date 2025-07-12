/**
 * freq_div.v
 * 
 * Refactored Frequency Divider Module
 * 
 * Inputs:
 *   CLK_in - 100 MHz clock input
 *   RST    - Asynchronous active-high reset
 * 
 * Outputs:
 *   CLK_50 - 50 MHz clock output (CLK_in divided by 2)
 *   CLK_10 - 10 MHz clock output (CLK_in divided by 10)
 *   CLK_1  -  1 MHz clock output (CLK_in divided by 100)
 * 
 * Implementation:
 *   Single always block with counters for half periods.
 *   Outputs toggle when counters reach half period thresholds.
 */

module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Half periods (number of CLK_in cycles per half period)
    localparam HALF_PERIOD_50  = 1;  // 100MHz / 2 -> toggle every 1 cycle
    localparam HALF_PERIOD_10  = 5;  // 100MHz / 10 -> toggle every 5 cycles
    localparam HALF_PERIOD_1   = 50; // 100MHz / 100 -> toggle every 50 cycles

    // Counters for half periods
    reg [6:0] cnt_50;  // 7 bits sufficient to count up to 50
    reg [6:0] cnt_10;
    reg [6:0] cnt_1;

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
            cnt_50 <= 7'd0;
            cnt_10 <= 7'd0;
            cnt_1  <= 7'd0;
        end else begin
            // CLK_50 counter and toggle
            if (cnt_50 == HALF_PERIOD_50 - 1) begin
                cnt_50 <= 7'd0;
                CLK_50 <= ~CLK_50;
            end else begin
                cnt_50 <= cnt_50 + 7'd1;
            end

            // CLK_10 counter and toggle
            if (cnt_10 == HALF_PERIOD_10 - 1) begin
                cnt_10 <= 7'd0;
                CLK_10 <= ~CLK_10;
            end else begin
                cnt_10 <= cnt_10 + 7'd1;
            end

            // CLK_1 counter and toggle
            if (cnt_1 == HALF_PERIOD_1 - 1) begin
                cnt_1 <= 7'd0;
                CLK_1 <= ~CLK_1;
            end else begin
                cnt_1 <= cnt_1 + 7'd1;
            end
        end
    end

endmodule