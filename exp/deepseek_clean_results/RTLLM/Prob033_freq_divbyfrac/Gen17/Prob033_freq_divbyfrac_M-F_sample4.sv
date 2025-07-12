module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg clk_div1, clk_div2;

// 7-cycle counter (4+3 pattern)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
    end
end

// First phase (4-cycle toggle)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div1 <= 1'b0;
    end else if (counter == 3'd3 || counter == 3'd6) begin
        clk_div1 <= ~clk_div1;
    end
end

// Second phase (3-cycle toggle with half-cycle shift)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div2 <= 1'b0;
    end else if (counter == 3'd2 || counter == 3'd5) begin
        clk_div2 <= ~clk_div2;
    end
end

// Combine phases to get 3.5x division
assign clk_div = clk_div1 | clk_div2;

endmodule