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
        
        // Phase A: high for cycles 0-3 (first 4 cycles)
        phase_a <= (counter < 3'd4);
        
        // Phase B: high for cycles 4-6 (last 3 cycles)
        phase_b <= (counter >= 3'd4);
    end
end

// Combine phases with OR for final output
assign clk_div = phase_a | phase_b;

endmodule