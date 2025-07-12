module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// 7-state counter for 3.5x division (alternates 4 and 3 cycles)
reg [2:0] cnt;
wire cnt_max = (cnt == 3'd6);

// Phase generation registers
reg phase0;  // 0° phase
reg phase180; // 180° phase

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 3'b0;
    end else begin
        cnt <= cnt_max ? 3'b0 : cnt + 1'b1;
    end
end

// Phase 0 generation (4 cycles high, 3 cycles low)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase0 <= 1'b0;
    end else begin
        phase0 <= (cnt < 3'd4) ? 1'b1 : 1'b0;
    end
end

// Phase 180 generation (shifted by half period)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase180 <= 1'b0;
    end else begin
        phase180 <= (cnt < 3'd4) ? 1'b1 : 1'b0;
    end
end

// Final output combines both phases
assign clk_div = phase0 | phase180;

endmodule