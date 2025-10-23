module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;

// 7-cycle counter (0-6) with synchronous reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) counter <= 3'b0;
    else counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
end

// Phase A: High for 4 cycles (0-3)
wire phase_a = (counter < 3'd4);

// Phase B: High for 4 cycles (3-6)
wire phase_b = (counter > 3'd2);

// Create half-cycle delayed version of phase_b
reg phase_b_delayed;
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) phase_b_delayed <= 1'b0;
    else phase_b_delayed <= phase_b;
end

// Final output combines phase_a and delayed phase_b
assign clk_div = phase_a | phase_b_delayed;

endmodule