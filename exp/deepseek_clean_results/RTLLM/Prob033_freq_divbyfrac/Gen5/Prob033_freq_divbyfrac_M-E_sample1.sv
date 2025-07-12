module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] ring_counter;
reg phase_a, phase_b;
wire phase_b_sync;

// Ring counter (0-6) on positive edge
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        ring_counter <= 3'b0;
    end else begin
        ring_counter <= (ring_counter == 3'd6) ? 3'b0 : ring_counter + 1'b1;
    end
end

// Phase A generation (4 high, 3 low)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_a <= 1'b0;
    end else begin
        case (ring_counter)
            3'd0: phase_a <= 1'b1;
            3'd4: phase_a <= 1'b0;
            default: phase_a <= phase_a;
        endcase
    end
end

// Phase B generation (3 high, 4 low) on negative edge
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_b <= 1'b1;
    end else begin
        case (ring_counter)
            3'd3: phase_b <= 1'b0;
            3'd6: phase_b <= 1'b1;
            default: phase_b <= phase_b;
        endcase
    end
end

// Synchronize phase_b to avoid metastability
sync_cell sync_phase_b (
    .d(phase_b),
    .clk(clk),
    .rst_n(rst_n),
    .q(phase_b_sync)
);

// XOR combination for sharp transitions
assign clk_div = phase_a ^ phase_b_sync;

endmodule

// Synchronizer cell for phase alignment
module sync_cell (
    input wire d,
    input wire clk,
    input wire rst_n,
    output reg q
);
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) q <= 1'b0;
    else q <= d;
end
endmodule