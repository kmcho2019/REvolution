module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;  // 0-6 counter for 7-cycle period
reg clk_pos, clk_neg;

// Main 7-cycle counter
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 6) ? 3'b0 : counter + 1;
    end
end

// Positive edge triggered clock (4 cycles high, 3 low)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_pos <= 1'b0;
    end else begin
        clk_pos <= (counter < 4);
    end
end

// Negative edge triggered clock (phase shifted)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_neg <= 1'b0;
    end else begin
        clk_neg <= (counter < 3) || (counter == 6);
    end
end

// Combined output
assign clk_div = clk_pos | clk_neg;

endmodule