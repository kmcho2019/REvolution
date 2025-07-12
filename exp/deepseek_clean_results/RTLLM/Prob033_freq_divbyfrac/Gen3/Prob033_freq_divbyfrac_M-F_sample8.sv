module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Phase counters
reg [2:0] cnt_a;  // 4-cycle counter (0-3)
reg [2:0] cnt_b;  // 3-cycle counter (0-2)

// Phase signals
reg phase_a;
reg phase_b;

// Phase A generation (4-clock period)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_a <= 3'd0;
        phase_a <= 1'b0;
    end else begin
        if (cnt_a == 3'd3) begin
            cnt_a <= 3'd0;
            phase_a <= ~phase_a;
        end else begin
            cnt_a <= cnt_a + 1;
        end
    end
end

// Phase B generation (3-clock period, 180° offset)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_b <= 3'd0;
        phase_b <= 1'b0;
    end else begin
        if (cnt_b == 3'd2) begin
            cnt_b <= 3'd0;
            phase_b <= ~phase_b;
        end else begin
            cnt_b <= cnt_b + 1;
        end
    end
end

// Output generation (OR of both phases)
assign clk_div = phase_a | phase_b;

endmodule