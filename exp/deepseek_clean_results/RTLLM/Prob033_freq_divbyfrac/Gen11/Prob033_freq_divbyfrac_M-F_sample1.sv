module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] cycle_count;  // Counts 0-6 (7 cycles total)
reg clock_a;
reg clock_b;

// Cycle counter for 3.5x division (7 cycles)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cycle_count <= 3'b0;
    end else begin
        cycle_count <= (cycle_count == 3'd6) ? 3'b0 : cycle_count + 1;
    end
end

// Clock A generation (4 cycles high, 3 low)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clock_a <= 1'b0;
    end else begin
        clock_a <= (cycle_count < 3'd4) ? 1'b1 : 1'b0;
    end
end

// Clock B generation (phase-shifted version)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clock_b <= 1'b0;
    end else begin
        clock_b <= (cycle_count >= 3'd4) ? 1'b1 : 1'b0;
    end
end

// Combine clocks with XOR for proper fractional division
assign clk_div = clock_a ^ clock_b;

endmodule