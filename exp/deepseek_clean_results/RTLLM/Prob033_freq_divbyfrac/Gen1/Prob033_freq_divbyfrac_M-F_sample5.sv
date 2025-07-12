module freq_divbyfrac (
    input clk,
    input rst_n,
    output clk_div
);

// Parameters
parameter MUL2_DIV_CLK = 7;  // 2*3.5 = 7 for fractional division

// Internal signals
reg [2:0] counter;
reg clk_div_p;
reg clk_div_n;

// Counter logic - counts 0 to 6 (7 cycles)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == MUL2_DIV_CLK - 1) ? 3'b0 : counter + 1;
    end
end

// Primary phase generation (4 high, 3 low)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_p <= 1'b0;
    end else begin
        clk_div_p <= (counter < 4) ? 1'b1 : 1'b0;
    end
end

// Secondary phase generation (shifted by half cycle)
// Adjusted to properly interleave with primary phase
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_n <= 1'b0;
    end else begin
        // Shifted by half cycle and inverted pattern
        if (counter == 3'b110 || counter < 3'b010) begin
            clk_div_n <= 1'b1;
        end else begin
            clk_div_n <= 1'b0;
        end
    end
end

// Combine both phases to create final output
assign clk_div = clk_div_p | clk_div_n;

endmodule