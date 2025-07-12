module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg phase_a, phase_b;

// 7-state counter (0-6) for 3.5x division
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'd0;
    end else begin
        counter <= (counter == 3'd6) ? 3'd0 : counter + 1;
    end
end

// Generate phase A (4-clock high, 3-clock low)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_a <= 1'b0;
    end else begin
        phase_a <= (counter < 3'd4) ? 1'b1 : 1'b0;
    end
end

// Generate phase B (3-clock high, 4-clock low) with 180° offset
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_b <= 1'b0;
    end else begin
        phase_b <= (counter < 3'd3) ? 1'b1 : 1'b0;
    end
end

// Combine phases to create final output
assign clk_div = phase_a | phase_b;

endmodule