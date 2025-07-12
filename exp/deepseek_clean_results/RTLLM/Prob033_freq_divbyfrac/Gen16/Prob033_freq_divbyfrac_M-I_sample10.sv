module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg clk_a, clk_b;
wire [2:0] counter_delayed;

// Main counter (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
    end
end

// Phase-shifted counter (delayed by 3.5 cycles)
assign counter_delayed = (counter + 3'd4) % 3'd7;

// Phase A generation (4 cycles high, 3 low)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_a <= 1'b0;
    end else begin
        clk_a <= (counter < 3'd4);
    end
end

// Phase B generation (shifted version of same pattern)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_b <= 1'b0;
    end else begin
        clk_b <= (counter_delayed < 3'd4);
    end
end

// Final output combines both phases
assign clk_div = clk_a | clk_b;

endmodule