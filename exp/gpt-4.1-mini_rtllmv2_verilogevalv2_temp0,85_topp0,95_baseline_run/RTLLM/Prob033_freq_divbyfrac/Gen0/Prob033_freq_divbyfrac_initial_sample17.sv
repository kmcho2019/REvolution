module freq_divbyfrac (
    input  wire clk,      // Input clock
    input  wire rst_n,    // Active low reset
    output wire clk_div   // Fractionally divided clock output
);

// Parameters for division by 3.5 (7 counts)
localparam integer MUL2_DIV_CLK = 7;

// Counters and signals
reg [2:0] cnt_pos;    // Counter for posedge domain (counts 0 to 6)
reg [2:0] cnt_neg;    // Counter for negedge domain (counts 0 to 6)

reg clk_div_pos;      // Divided clock from posedge domain
reg clk_div_neg;      // Divided clock from negedge domain

// POSITIVE EDGE DOMAIN: generates clk_div_pos with high for 4 counts, low for 3 counts
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_pos <= 3'd0;
        clk_div_pos <= 1'b0;
    end else begin
        if (cnt_pos == MUL2_DIV_CLK - 1)
            cnt_pos <= 3'd0;
        else
            cnt_pos <= cnt_pos + 3'd1;

        // High for counts 0,1,2,3 (4 cycles), low for 4,5,6 (3 cycles)
        clk_div_pos <= (cnt_pos < 4) ? 1'b1 : 1'b0;
    end
end

// NEGATIVE EDGE DOMAIN: generates clk_div_neg with high for 3 counts, low for 4 counts
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_neg <= 3'd0;
        clk_div_neg <= 1'b0;
    end else begin
        if (cnt_neg == MUL2_DIV_CLK - 1)
            cnt_neg <= 3'd0;
        else
            cnt_neg <= cnt_neg + 3'd1;

        // High for counts 0,1,2 (3 cycles), low for 3,4,5,6 (4 cycles)
        clk_div_neg <= (cnt_neg < 3) ? 1'b1 : 1'b0;
    end
end

// Final output is OR of the two phase-shifted clocks to achieve fractional divide-by-3.5
assign clk_div = clk_div_pos | clk_div_neg;

endmodule