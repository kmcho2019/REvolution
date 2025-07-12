module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// State counters for both phases
reg [2:0] pos_phase, neg_phase;

// Positive edge counter (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pos_phase <= 3'b0;
    end else begin
        pos_phase <= (pos_phase == 6) ? 3'b0 : pos_phase + 1;
    end
end

// Negative edge counter (0-6) for phase shift
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        neg_phase <= 3'b0;
    end else begin
        neg_phase <= (neg_phase == 6) ? 3'b0 : neg_phase + 1;
    end
end

// Clock generation using continuous assignment
wire clk_pos = (pos_phase < 4) && rst_n;  // Active for 4 cycles
wire clk_neg = (neg_phase < 3) && rst_n;  // Active for 3 cycles (phase shifted)

// Final output clock
assign clk_div = clk_pos | clk_neg;

endmodule