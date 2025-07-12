/**
 * freq_div.v
 * 
 * Frequency Divider Module
 * 
 * Input:
 *   CLK_in - 100 MHz clock input
 *   RST    - Asynchronous active-high reset
 * 
 * Outputs:
 *   CLK_50 - 50 MHz clock output (CLK_in divided by 2)
 *   CLK_10 - 10 MHz clock output (CLK_in divided by 10)
 *   CLK_1  -  1 MHz clock output (CLK_in divided by 100)
 * 
 * The module implements three independent counters and toggles each output clock 
 * at precise count thresholds to achieve the desired frequency division.
 */

module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Parameterized counter max values for toggle points
    localparam CNT_10_MAX  = 3'd4;   // Toggle CLK_10 at count 4 (divide by 10)
    localparam CNT_100_MAX = 6'd49;  // Toggle CLK_1  at count 49 (divide by 100)

    // Counters for frequency division
    reg [2:0]  cnt_10;    // 3-bit counter for CLK_10
    reg [5:0]  cnt_100;   // 6-bit counter for CLK_1

    // CLK_50 generation: divide by 2, toggle on every clock cycle
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // CLK_10 generation: divide by 10, toggle on reaching CNT_10_MAX
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_10 <= 1'b0;
            cnt_10 <= 3'd0;
        end else begin
            if (cnt_10 == CNT_10_MAX) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 3'd0;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end
        end
    end

    // CLK_1 generation: divide by 100, toggle on reaching CNT_100_MAX
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1 <= 1'b0;
            cnt_100 <= 6'd0;
        end else begin
            if (cnt_100 == CNT_100_MAX) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= 6'd0;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule