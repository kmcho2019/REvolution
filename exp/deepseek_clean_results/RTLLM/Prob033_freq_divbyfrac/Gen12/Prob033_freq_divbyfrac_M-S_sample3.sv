module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg phase_a, phase_b;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
        phase_a <= 1'b0;
        phase_b <= 1'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
        
        // Phase A: high for first 3 cycles (0-2)
        phase_a <= (counter < 3'd3);
        
        // Phase B: high for next 4 cycles (3-6)
        phase_b <= (counter >= 3'd3);
    end
end

// Combine phases with XOR for proper fractional division
assign clk_div = phase_a ^ phase_b;

endmodule