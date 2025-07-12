module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] cycle_count;  // Counts 0-6 (7 cycles total)
reg main_clock;
reg phase_clock;

// Cycle counter for 3.5x division (7 cycles)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cycle_count <= 3'b0;
    end else begin
        cycle_count <= (cycle_count == 3'd6) ? 3'b0 : cycle_count + 1;
    end
end

// Main clock generation (4 cycles high, 3 low)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        main_clock <= 1'b0;
    end else begin
        main_clock <= (cycle_count < 3'd4) ? 1'b1 : 1'b0;
    end
end

// Phase-shifted clock generation (half-cycle delayed)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_clock <= 1'b0;
    end else begin
        phase_clock <= (cycle_count < 3'd4) ? 1'b1 : 1'b0;
    end
end

// Combine both clocks for final output
assign clk_div = main_clock | phase_clock;

endmodule