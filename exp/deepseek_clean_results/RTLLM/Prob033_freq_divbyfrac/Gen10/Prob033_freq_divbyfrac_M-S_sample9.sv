module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg clk_phase1, clk_phase2;

// 7-cycle counter (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) counter <= 3'b0;
    else counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
end

// Phase1 generation (high for 0-3)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) clk_phase1 <= 1'b0;
    else clk_phase1 <= (counter < 3'd4);
end

// Phase2 generation (high for 4-6) with half-cycle shift
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) clk_phase2 <= 1'b0;
    else clk_phase2 <= (counter > 3'd3);
end

// Combined output
assign clk_div = clk_phase1 | clk_phase2;

endmodule