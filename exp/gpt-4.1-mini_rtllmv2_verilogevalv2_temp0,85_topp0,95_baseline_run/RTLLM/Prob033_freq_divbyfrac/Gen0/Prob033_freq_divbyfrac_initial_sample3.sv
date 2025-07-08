module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

// Parameters
localparam MUL2_DIV_CLK = 7;

// Counter for dividing clock by 7
reg [2:0] cnt_pos; // Counter for posedge domain
reg [2:0] cnt_neg; // Counter for negedge domain

// Intermediate divided clocks
reg div_clk_pos;  // Toggled at posedge domain (uneven period 4 cycles)
reg div_clk_neg;  // Toggled at negedge domain (uneven period 3 cycles)

// Counter increments on posedge clock
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_pos <= 3'd0;
        div_clk_pos <= 1'b0;
    end else begin
        if (cnt_pos == MUL2_DIV_CLK - 1)
            cnt_pos <= 3'd0;
        else
            cnt_pos <= cnt_pos + 3'd1;

        // Toggle div_clk_pos on count 0 and 4 to create uneven period (4 cycles high, 3 cycles low)
        if (cnt_pos == 3'd0)
            div_clk_pos <= 1'b1;
        else if (cnt_pos == 3'd4)
            div_clk_pos <= 1'b0;
    end
end

// Counter increments on negedge clock
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_neg <= 3'd0;
        div_clk_neg <= 1'b0;
    end else begin
        if (cnt_neg == MUL2_DIV_CLK - 1)
            cnt_neg <= 3'd0;
        else
            cnt_neg <= cnt_neg + 3'd1;

        // Toggle div_clk_neg on count 0 and 3 to create uneven period (3 cycles high, 4 cycles low)
        if (cnt_neg == 3'd0)
            div_clk_neg <= 1'b1;
        else if (cnt_neg == 3'd3)
            div_clk_neg <= 1'b0;
    end
end

// Final fractional divided clock: OR of two phase shifted divided clocks
assign clk_div = div_clk_pos | div_clk_neg;

endmodule