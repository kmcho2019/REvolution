module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg phase_a, phase_b;
reg delayed_phase_b;

// Main counter (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
    end
end

// Phase A generation (4 cycles high, 3 low)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_a <= 1'b0;
    end else begin
        phase_a <= (counter < 3'd4);
    end
end

// Phase B generation (3 cycles high, 4 low)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_b <= 1'b0;
    end else begin
        phase_b <= (counter >= 3'd3);
    end
end

// Half-cycle delayed version of phase B
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        delayed_phase_b <= 1'b0;
    end else begin
        delayed_phase_b <= phase_b;
    end
end

// Final output combines both phases with XOR
assign clk_div = phase_a ^ delayed_phase_b;

endmodule