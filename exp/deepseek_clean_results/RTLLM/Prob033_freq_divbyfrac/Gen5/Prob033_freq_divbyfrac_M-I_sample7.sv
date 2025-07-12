module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg clk_phase_a;
reg clk_phase_b;

// Single-edge counter (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
    end
end

// Phase A: 4 high, 3 low
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_phase_a <= 1'b0;
    end else begin
        clk_phase_a <= (counter < 3'd4);
    end
end

// Phase B: same pattern but shifted by 3.5 cycles
// Implemented by comparing against (counter + 4) mod 7
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_phase_b <= 1'b0;
    end else begin
        clk_phase_b <= ((counter + 3'd4) % 3'd7) < 3'd4;
    end
end

// Combine both phases
assign clk_div = clk_phase_a | clk_phase_b;

endmodule