module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg phase_a;
reg phase_b;

// 7-cycle counter (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
    end
end

// Phase A generation (first half period)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_a <= 1'b0;
    end else begin
        phase_a <= (counter < 3'd4);  // High for 4 cycles (0-3)
    end
end

// Phase B generation (second half period, 180° shifted)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_b <= 1'b0;
    end else begin
        phase_b <= (counter >= 3'd3) && (counter != 3'd6);  // High for 3 cycles (4-6)
    end
end

// Combine phases with OR for final output
assign clk_div = phase_a | phase_b;

endmodule