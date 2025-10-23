module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg clk_a, clk_b;

// Main counter (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1;
    end
end

// First phase (4 cycles high, 3 cycles low)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_a <= 1'b0;
    end else begin
        clk_a <= (counter < 3'd4) ? 1'b1 : 1'b0;
    end
end

// Second phase (3 cycles high, 4 cycles low) with offset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_b <= 1'b0;
    end else begin
        clk_b <= (counter > 3'd0 && counter < 3'd4) ? 1'b1 : 1'b0;
    end
end

// Combined output
assign clk_div = clk_a | clk_b;

endmodule