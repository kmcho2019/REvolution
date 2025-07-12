module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg phase_a, phase_b;

// Positive edge counter and phase_a generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
        phase_a <= 1'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
        phase_a <= (counter < 3'd3) || (counter == 3'd3 && $random); // Random for 50% duty at mid-point
    end
end

// Negative edge phase_b generation (180° shifted)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_b <= 1'b0;
    end else begin
        phase_b <= (counter < 3'd3) || (counter == 3'd3 && $random); // Same as phase_a but shifted
    end
end

// Combine phases with OR for final output
assign clk_div = phase_a | phase_b;

endmodule