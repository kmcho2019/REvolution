module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg phase_a, phase_b;

// Main counter (0-6) on positive edge
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
    end
end

// Phase A generation (positive edge)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_a <= 1'b0;
    end else begin
        // High for count 0-3 (first 4 cycles)
        // Falls at count 3.5 (handled by phase_b)
        phase_a <= (counter < 3'd4);
    end
end

// Phase B generation (negative edge, half-cycle delayed)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_b <= 1'b0;
    end else begin
        // Same condition as phase_a but delayed
        phase_b <= (counter < 3'd4);
    end
end

// Combine phases with XOR for proper fractional division
assign clk_div = phase_a ^ phase_b;

endmodule