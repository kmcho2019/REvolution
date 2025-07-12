module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
wire phase_a, phase_b;

// Counter with synchronous reset
always @(posedge clk) begin
    if (!rst_n)
        counter <= 3'b0;
    else
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
end

// Phase A: high for first 3.5 cycles (0-3) - positive edge
assign phase_a = (counter < 3'd4);

// Phase B: high for last 3.5 cycles (4-6) - negative edge
reg phase_b_reg;
always @(negedge clk) begin
    if (!rst_n)
        phase_b_reg <= 1'b0;
    else
        phase_b_reg <= (counter >= 3'd3); // Starts half-cycle earlier
end
assign phase_b = phase_b_reg;

// Combine phases with OR for final output
assign clk_div = phase_a | phase_b;

endmodule