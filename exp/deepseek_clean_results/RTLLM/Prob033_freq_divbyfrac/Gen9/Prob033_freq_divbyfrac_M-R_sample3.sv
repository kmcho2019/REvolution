module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
wire clk_phase1, clk_phase2;

// 7-cycle counter (0-6) with synchronous reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) counter <= 3'b0;
    else counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
end

// Phase1 generation (high from 0 to 3.5)
assign clk_phase1 = (counter < 3'd4) && (counter != 3'd3 || ~clk);

// Phase2 generation (high from 3.5 to 7) with half-cycle shift
assign clk_phase2 = (counter > 3'd3) || (counter == 3'd3 && clk);

// Combined output with OR operation
assign clk_div = clk_phase1 | clk_phase2;

endmodule