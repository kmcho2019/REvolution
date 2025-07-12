module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] cycle_counter;
reg phase_a, phase_b;
wire phase_a_ff, phase_b_ff;

// Dual-edge counter for precise timing
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cycle_counter <= 3'b0;
    end else begin
        cycle_counter <= (cycle_counter == 3'd6) ? 3'b0 : cycle_counter + 1'b1;
    end
end

// Phase A generation (4-cycle period)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_a <= 1'b0;
    end else begin
        phase_a <= (cycle_counter < 3'd4) ? 1'b1 : 1'b0;
    end
end

// Phase B generation (3-cycle period, 180° offset)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_b <= 1'b0;
    end else begin
        phase_b <= (cycle_counter < 3'd3) ? 1'b1 : 1'b0;
    end
end

// Phase synchronization flip-flops
FDRE #(.INIT(1'b0)) ff_phase_a (
    .C(clk),
    .CE(1'b1),
    .D(phase_a),
    .R(~rst_n),
    .Q(phase_a_ff)
);

FDRE #(.INIT(1'b0)) ff_phase_b (
    .C(clk),
    .CE(1'b1),
    .D(phase_b),
    .R(~rst_n),
    .Q(phase_b_ff)
);

// Final output combination
assign clk_div = phase_a_ff | phase_b_ff;

endmodule