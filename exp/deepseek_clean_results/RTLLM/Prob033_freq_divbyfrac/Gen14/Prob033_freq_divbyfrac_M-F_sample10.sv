module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg phase_a, phase_b;
reg phase_a_delayed;
wire phase_b_advanced;

// Main counter and phase generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
        phase_a <= 1'b0;
        phase_b <= 1'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
        
        // Phase A: high for 4 cycles (0-3)
        phase_a <= (counter < 3'd4);
        
        // Phase B: high for 3 cycles (0-2)
        phase_b <= (counter < 3'd3);
    end
end

// Phase B advanced by half cycle (pre-calculate next state)
assign phase_b_advanced = (counter < 3'd2) || (counter == 3'd6);

// Phase A delayed by half cycle
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_a_delayed <= 1'b0;
    end else begin
        phase_a_delayed <= phase_a;
    end
end

// Combine phases: use original phase_a for first half,
// and advanced phase_b for second half
assign clk_div = phase_a_delayed | phase_b_advanced;

endmodule