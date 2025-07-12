module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg phase_a, phase_b;
reg toggle;

// 7-state counter (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
    end
end

// Toggle flip-flop for phase generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        toggle <= 1'b0;
    end else if (counter == 3'd6) begin
        toggle <= ~toggle;
    end
end

// Phase A generation (posedge triggered)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_a <= 1'b0;
    end else begin
        phase_a <= (counter < 3'd4) ^ toggle;
    end
end

// Phase B generation (negedge triggered, 180° out of phase)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_b <= 1'b0;
    end else begin
        phase_b <= ((counter > 3'd2) && (counter < 3'd6)) ^ toggle;
    end
end

// Final output combines both phases
assign clk_div = phase_a ^ phase_b;

endmodule