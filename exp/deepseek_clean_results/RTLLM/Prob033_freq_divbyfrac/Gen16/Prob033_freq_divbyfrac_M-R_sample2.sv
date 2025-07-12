module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] cycle_counter;
reg phase_a, phase_b;
reg phase_a_sync, phase_b_sync;

// Main counter (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cycle_counter <= 3'b0;
    end else begin
        cycle_counter <= (cycle_counter == 3'd6) ? 3'b0 : cycle_counter + 1'b1;
    end
end

// Phase A generation (4 cycles high)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_a <= 1'b0;
    end else begin
        phase_a <= (cycle_counter < 3'd4);
    end
end

// Phase B generation (3 cycles high, negedge aligned)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_b <= 1'b0;
    end else begin
        phase_b <= (cycle_counter < 3'd3);
    end
end

// Synchronize phase_b to posedge clock
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_a_sync <= 1'b0;
        phase_b_sync <= 1'b0;
    end else begin
        phase_a_sync <= phase_a;
        phase_b_sync <= phase_b;
    end
end

// Combine phases for final output
assign clk_div = phase_a_sync | phase_b_sync;

endmodule