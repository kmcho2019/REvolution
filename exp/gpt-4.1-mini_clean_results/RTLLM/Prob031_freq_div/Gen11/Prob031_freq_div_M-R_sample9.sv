/**
 * freq_div.v
 *
 * Frequency Divider Module (Refactored)
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
 * The module divides the input clock frequency using separate counters and toggling outputs
 * in independent always blocks for clarity and modularity.
 */

module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Counters for frequency division
    reg cnt_50;            // 1-bit counter for divide by 2
    reg [2:0] cnt_10;      // 3-bit counter for divide by 10 (counts 0-4)
    reg [5:0] cnt_100;     // 6-bit counter for divide by 100 (counts 0-49)

    // Generate CLK_50 (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_50 <= 1'b0;
            CLK_50 <= 1'b0;
        end else begin
            cnt_50 <= ~cnt_50;
            if (cnt_50)
                CLK_50 <= ~CLK_50;
        end
    end

    // Generate CLK_10 (divide by 10)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_10 <= 3'd0;
            CLK_10 <= 1'b0;
        end else begin
            if (cnt_10 == 3'd4) begin
                cnt_10 <= 3'd0;
                CLK_10 <= ~CLK_10;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end
        end
    end

    // Generate CLK_1 (divide by 100)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_100 <= 6'd0;
            CLK_1 <= 1'b0;
        end else begin
            if (cnt_100 == 6'd49) begin
                cnt_100 <= 6'd0;
                CLK_1 <= ~CLK_1;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule