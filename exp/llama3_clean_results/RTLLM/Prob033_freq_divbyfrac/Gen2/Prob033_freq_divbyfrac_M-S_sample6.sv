module freq_divbyfrac(
    input clk,      // Input clock signal
    input rst_n,     // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameter for the multiplier (3.5x division)
localparam MUL2_DIV_CLK = 7;

// Signals for uneven clock periods
reg [2:0] counter;
reg [2:0] state;
reg clk_div_4;
reg clk_div_3;

// State machine for frequency divider
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'd0;
        state <= 3'd0;
        clk_div_4 <= 1'b0;
        clk_div_3 <= 1'b0;
    end else begin
        case (state)
            3'd0: begin
                if (counter < 3'd3) begin
                    counter <= counter + 1;
                end else begin
                    counter <= 3'd0;
                    state <= 3'd1;
                end
            end
            3'd1: begin
                if (counter < 3'd2) begin
                    counter <= counter + 1;
                end else begin
                    counter <= 3'd0;
                    state <= 3'd0;
                end
            end
        endcase

        // Generate uneven clock periods
        if (state == 3'd0 && counter == 3'd0) begin
            clk_div_4 <= 1'b1;
        end else if (state == 3'd0 && counter == 3'd3) begin
            clk_div_4 <= 1'b0;
        end

        if (state == 3'd1 && counter == 3'd0) begin
            clk_div_3 <= 1'b1;
        end else if (state == 3'd1 && counter == 3'd2) begin
            clk_div_3 <= 1'b0;
        end
    end
end

// Phase-shift the uneven clock periods and generate the final divided clock output
assign clk_div = (clk_div_4 & ~clk_div_3) | (~clk_div_4 & clk_div_3);

endmodule