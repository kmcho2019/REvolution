module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] pos_counter;
reg [2:0] neg_counter;
reg pos_pulse;
reg neg_pulse;

// Positive edge counter and pulse generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pos_counter <= 3'b0;
        pos_pulse <= 1'b0;
    end else begin
        pos_counter <= (pos_counter == 3'd6) ? 3'b0 : pos_counter + 1'b1;
        pos_pulse <= (pos_counter == 3'd0) || (pos_counter == 3'd3);
    end
end

// Negative edge counter and pulse generation
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        neg_counter <= 3'b0;
        neg_pulse <= 1'b0;
    end else begin
        neg_counter <= (neg_counter == 3'd6) ? 3'b0 : neg_counter + 1'b1;
        neg_pulse <= (neg_counter == 3'd1) || (neg_counter == 3'd5);
    end
end

// Output clock generation using SR latch
reg clk_div_reg;
always @(*) begin
    if (pos_pulse) clk_div_reg = 1'b1;
    else if (neg_pulse) clk_div_reg = 1'b0;
end

assign clk_div = clk_div_reg;

endmodule