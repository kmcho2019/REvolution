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
reg clk_div_delayed;

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b0;
        end else begin
            counter <= counter + 1;
        end
    end
end

// Positive phase clock generation (4 cycles high, 3 low)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_p <= 1'b0;
    end else begin
        if (counter < 4) begin
            clk_div_p <= 1'b1;
        end else begin
            clk_div_p <= 1'b0;
        end
    end
end

// Negative phase clock generation (shifted by half cycle)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_n <= 1'b0;
    end else begin
        if (counter < 3) begin  // Adjusted for half-cycle shift
            clk_div_n <= 1'b1;
        end else begin
            clk_div_n <= 1'b0;
        end
    end
end

// Combine both phases to create final output
assign clk_div = clk_div_p | clk_div_n;

endmodule