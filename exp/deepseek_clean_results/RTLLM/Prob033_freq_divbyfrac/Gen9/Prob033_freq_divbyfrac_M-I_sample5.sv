module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg phase_a, phase_b;

// 7-cycle counter (0-6) with double-edge counting
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
    end
end

// Generate phase A (first 3.5 cycles)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_a <= 1'b0;
    end else begin
        phase_a <= (counter < 3'd3) || (counter == 3'd3 && !clk);
    end
end

// Generate phase B (second 3.5 cycles) - shifted by half cycle
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_b <= 1'b0;
    end else begin
        phase_b <= (counter > 3'd3) || (counter == 3'd3 && clk);
    end
end

// Combine phases with OR to create final output
assign clk_div = phase_a | phase_b;

endmodule