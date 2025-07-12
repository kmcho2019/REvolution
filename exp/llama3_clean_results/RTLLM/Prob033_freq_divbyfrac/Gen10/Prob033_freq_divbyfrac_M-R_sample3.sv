module freq_divbyfrac(
    input clk,      // Input clock signal
    input rst_n,     // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameter for the multiplier (3.5x division)
localparam MUL2_DIV_CLK = 7;

// Counter for digital frequency divider
reg [2:0] div_counter;

// Intermediate clock signals
reg clk_div_4;
reg clk_div_3;
reg clk_div_4_dly;
reg clk_div_3_adv;

// Phase-shifted clock signals
wire clk_div_4_pos;
wire clk_div_3_neg;

// Output clock signal generation
assign clk_div_4_pos = clk_div_4;
assign clk_div_3_neg = clk_div_3;

assign clk_div = clk_div_4_pos | clk_div_3_neg;

// Digital frequency divider implementation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        div_counter <= 3'd0;
        clk_div_4 <= 1'b0;
        clk_div_3 <= 1'b0;
        clk_div_4_dly <= 1'b0;
        clk_div_3_adv <= 1'b0;
    end else begin
        // 3.5x frequency division using digital frequency divider
        case (div_counter)
            3'd0, 3'd1, 3'd2, 3'd3: begin
                div_counter <= div_counter + 1;
                clk_div_4 <= 1'b1;
            end
            3'd4, 3'd5, 3'd6: begin
                div_counter <= div_counter + 1;
                clk_div_3 <= 1'b1;
            end
            default: begin
                div_counter <= 3'd0;
                clk_div_4 <= 1'b0;
                clk_div_3 <= 1'b0;
            end
        endcase
        
        // Phase-shifting
        clk_div_4_dly <= clk_div_4;
        clk_div_3_adv <= clk_div_3;
        
        // Advance and delay the clocks
        if (div_counter == 3'd4) begin
            clk_div_3_adv <= 1'b1;
        end else if (div_counter == 3'd0) begin
            clk_div_4_dly <= 1'b0;
        end
        
        // Update div_3 and div_4
        clk_div_4 <= clk_div_4_dly;
        clk_div_3 <= clk_div_3_adv;
    end
end

endmodule