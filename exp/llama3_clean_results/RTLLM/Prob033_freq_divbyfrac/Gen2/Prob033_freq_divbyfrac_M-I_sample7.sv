module freq_divbyfrac(
    input clk,      // Input clock signal
    input rst_n,     // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameter for the multiplier (3.5x division)
localparam MUL2_DIV_CLK = 7;

// Signals for uneven clock periods
reg clk_div_4;
reg clk_div_3;
reg clk_div_4_dly;  // Delayed version of clk_div_4
reg clk_div_3_adv;  // Advanced version of clk_div_3

// State machine for frequency divider
reg [2:0] state;
reg [2:0] next_state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset all signals
        state <= 3'd0;
        clk_div_4 <= 1'b0;
        clk_div_3 <= 1'b0;
        clk_div_4_dly <= 1'b0;
        clk_div_3_adv <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        case (state)
            3'd0: begin
                // Generate 4-clock cycle period
                clk_div_4 <= 1'b1;
                next_state <= 3'd1;
            end
            3'd1, 3'd2, 3'd3: begin
                next_state <= state + 1;
            end
            3'd4: begin
                // End of 4-clock cycle period
                clk_div_4 <= 1'b0;
                next_state <= 3'd5;
            end
            3'd5: begin
                // Generate 3-clock cycle period
                clk_div_3 <= 1'b1;
                next_state <= 3'd6;
            end
            3'd6: begin
                // End of 3-clock cycle period
                clk_div_3 <= 1'b0;
                next_state <= 3'd0;
            end
        endcase
        state <= next_state;

        // Phase-shift the uneven clock periods
        if (state == 3'd0) begin
            clk_div_4_dly <= 1'b1;
        end else if (state == 3'd4) begin
            clk_div_4_dly <= 1'b0;
        end

        if (state == 3'd2) begin
            clk_div_3_adv <= 1'b1;
        end else if (state == 3'd5) begin
            clk_div_3_adv <= 1'b0;
        end
    end
end

// Logically OR the phase-shifted clocks to produce the final divided clock output
assign clk_div = clk_div_4_dly | clk_div_3_adv;

endmodule