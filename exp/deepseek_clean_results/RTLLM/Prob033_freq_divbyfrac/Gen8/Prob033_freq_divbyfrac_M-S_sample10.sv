module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;

// 7-cycle counter (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
    end
end

// Generate two complementary phases
wire clk_phase1 = (counter < 3'd4);  // High for 0-3 (4 cycles)
wire clk_phase2 = (counter > 3'd2);  // High for 3-6 (4 cycles) - shifted

// XOR combines phases to create proper fractional division
assign clk_div = clk_phase1 ^ clk_phase2;

endmodule