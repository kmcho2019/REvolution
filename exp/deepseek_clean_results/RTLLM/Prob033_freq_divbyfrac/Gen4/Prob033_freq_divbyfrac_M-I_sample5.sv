module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// 3-bit counter for 7 cycles (0-6)
reg [2:0] count;

// Phase registers
reg phase_a;  // 4-clock period (50% duty)
reg phase_b;  // 3-clock period (50% duty, 180° offset)

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 3'd0;
    end else begin
        count <= (count == 3'd6) ? 3'd0 : count + 1;
    end
end

// Phase A generation (4-clock period)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_a <= 1'b1;
    end else begin
        case (count)
            3'd1: phase_a <= 1'b0;  // Fall after 2 clocks
            3'd3: phase_a <= 1'b1;  // Rise after 2 clocks
            default: phase_a <= phase_a;
        endcase
    end
end

// Phase B generation (3-clock period, 180° offset)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_b <= 1'b0;
    end else begin
        case (count)
            3'd0: phase_b <= 1'b1;  // Rise at start
            3'd3: phase_b <= 1'b0;  // Fall after 1.5 clocks
            3'd4: phase_b <= 1'b1;  // Rise after 1.5 clocks
            default: phase_b <= phase_b;
        endcase
    end
end

// Combine phases (no synchronization needed as transitions are edge-aligned)
assign clk_div = phase_a | phase_b;

endmodule