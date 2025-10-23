module freq_divbyfrac(
    input clk,      // Input clock signal
    input rst_n,     // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameter for the multiplier (3.5x division)
localparam MUL2_DIV_CLK = 7;

// Signals for uneven clock periods
reg [2:0] cnt_4;
reg [1:0] cnt_3;
reg clk_div_4;
reg clk_div_3;
reg clk_div_4_dly;  // Delayed version of clk_div_4
reg clk_div_3_adv;  // Advanced version of clk_div_3

// State machine for frequency divider
reg state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset all signals
        state <= 1'b0;
        cnt_4 <= 3'd0;
        cnt_3 <= 2'd0;
        clk_div_4 <= 1'b0;
        clk_div_3 <= 1'b0;
        clk_div_4_dly <= 1'b0;
        clk_div_3_adv <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        if (state == 1'b0) begin
            // Generate 4-clock cycle period
            if (cnt_4 == 3'd3) begin
                cnt_4 <= 3'd0;
                state <= 1'b1;
            end else begin
                cnt_4 <= cnt_4 + 1;
            end
            clk_div_4 <= (cnt_4 == 3'd0 || cnt_4 == 3'd1 || cnt_4 == 3'd2 || cnt_4 == 3'd3);
        end else if (state == 1'b1) begin
            // Generate 3-clock cycle period
            if (cnt_3 == 2'd2) begin
                cnt_3 <= 2'd0;
                state <= 1'b0;
            end else begin
                cnt_3 <= cnt_3 + 1;
            end
            clk_div_3 <= (cnt_3 == 2'd0 || cnt_3 == 2'd1 || cnt_3 == 2'd2);
        end

        // Phase-shift the uneven clock periods
        clk_div_4_dly <= clk_div_4;
        clk_div_3_adv <= clk_div_3;
    end
end

// Logically OR the phase-shifted clocks to produce the final divided clock output
assign clk_div = clk_div_4_dly | clk_div_3_adv;

endmodule