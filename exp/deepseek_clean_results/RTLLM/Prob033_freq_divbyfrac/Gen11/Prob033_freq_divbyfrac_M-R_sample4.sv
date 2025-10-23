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

// Phase generation using continuous assignment
wire phase_a = (counter < 3'd4);  // High for 4 cycles (0-3)
reg phase_b;

// Phase B is phase_a shifted by 3.5 cycles (using negedge)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) phase_b <= 1'b0;
    else phase_b <= (counter < 3'd4);
end

// Final output combines both phases
assign clk_div = phase_a | phase_b;

endmodule