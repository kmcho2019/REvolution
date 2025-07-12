module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// 7-bit rotating pattern (1000100 for 4 active, 3 inactive cycles)
reg [6:0] pattern = 7'b1000100;

// Edge-triggered sampling registers
reg posedge_sample;
reg negedge_sample;

// Rotate the pattern every full cycle
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pattern <= 7'b1000100;  // Reset to initial pattern
    end else begin
        pattern <= {pattern[5:0], pattern[6]};  // Rotate left
    end
end

// Sample on positive edge
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        posedge_sample <= 1'b0;
    end else begin
        posedge_sample <= pattern[0];
    end
end

// Sample on negative edge
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        negedge_sample <= 1'b0;
    end else begin
        negedge_sample <= pattern[3];  // 180° phase offset sample
    end
end

// Combine both edge samples
assign clk_div = posedge_sample | negedge_sample;

endmodule