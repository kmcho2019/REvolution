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

// Phase generation
wire phase_a = (counter < 3'd4);  // High for 4 cycles (0-3)
wire phase_b = (counter > 3'd2);  // High for 4 cycles (3-6)

// Half-cycle delayed versions
reg phase_a_delayed, phase_b_delayed;

always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_a_delayed <= 1'b0;
        phase_b_delayed <= 1'b0;
    end else begin
        phase_a_delayed <= phase_a;
        phase_b_delayed <= phase_b;
    end
end

// Combine phases with proper alignment
wire clk_div_a = phase_a | phase_b_delayed;
wire clk_div_b = phase_b | phase_a_delayed;

// Final output combines both paths
assign clk_div = clk_div_a | clk_div_b;

endmodule