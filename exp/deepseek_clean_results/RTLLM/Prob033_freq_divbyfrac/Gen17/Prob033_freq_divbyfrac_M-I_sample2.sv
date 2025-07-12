module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg phase_a, phase_b;
reg phase_a_delayed, phase_b_delayed;

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
        
        // Phase B: high for 3 cycles (4-6)
        phase_b <= (counter > 3'd3);
    end
end

// Precise half-cycle phase shifting
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_a_delayed <= 1'b0;
        phase_b_delayed <= 1'b0;
    end else begin
        phase_a_delayed <= phase_a;
        phase_b_delayed <= phase_b;
    end
end

// Improved phase combination using XOR
// Small delay to prevent glitches
wire clk_div_pre;
assign #1 clk_div_pre = phase_a ^ phase_b_delayed;
assign clk_div = clk_div_pre;

endmodule