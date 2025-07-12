module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] cnt4, cnt3;
reg phase4, phase3;
wire clk4, clk3;
reg toggle;

// 4-cycle counter (0-3)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt4 <= 3'b0;
    end else begin
        cnt4 <= (cnt4 == 3'd3) ? 3'b0 : cnt4 + 1'b1;
    end
end

// 3-cycle counter (0-2)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt3 <= 3'b0;
    end else begin
        cnt3 <= (cnt3 == 3'd2) ? 3'b0 : cnt3 + 1'b1;
    end
end

// Phase generation for each counter
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase4 <= 1'b0;
        phase3 <= 1'b0;
    end else begin
        phase4 <= (cnt4 < 3'd2) ? 1'b1 : 1'b0;  // 2 cycles high, 2 low
        phase3 <= (cnt3 < 3'd2) ? 1'b1 : 1'b0;   // 2 cycles high, 1 low
    end
end

// Alternation control between phases
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        toggle <= 1'b0;
    end else if (cnt4 == 3'd3 && cnt3 == 3'd2) begin
        toggle <= ~toggle;
    end
end

// Edge detection for phase blending
reg phase4_d, phase3_d;
always @(posedge clk) begin
    phase4_d <= phase4;
    phase3_d <= phase3;
end

wire edge4 = phase4 ^ phase4_d;
wire edge3 = phase3 ^ phase3_d;

// Final output generation
assign clk_div = toggle ? phase4 : phase3;

endmodule