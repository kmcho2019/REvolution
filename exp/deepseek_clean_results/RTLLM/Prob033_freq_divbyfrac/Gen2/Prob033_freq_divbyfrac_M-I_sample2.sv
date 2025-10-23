module freq_divbyfrac (
    input clk,
    input rst_n,
    output clk_div
);

reg [2:0] counter;
reg phase_a, phase_b;
reg delayed_phase_a;

// 3-bit counter (0-6) for 3.5x division
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1;
    end
end

// Phase A: 4 cycles high (0-3), 3 cycles low (4-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_a <= 1'b0;
    end else begin
        phase_a <= (counter <= 3'd3);
    end
end

// Phase B: 3 cycles high (1-3), 4 cycles low (0,4-6) with 180° phase shift
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_b <= 1'b0;
    end else begin
        phase_b <= (counter >= 3'd1 && counter <= 3'd3);
    end
end

// Delay phase_a by half cycle for edge alignment
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        delayed_phase_a <= 1'b0;
    end else begin
        delayed_phase_a <= phase_a;
    end
end

// Final output combines both phases
assign clk_div = (phase_a | delayed_phase_a) | phase_b;

endmodule