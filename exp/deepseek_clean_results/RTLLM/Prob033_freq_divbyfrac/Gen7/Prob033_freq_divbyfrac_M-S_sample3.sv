module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;

// Single-edge counter (counts 0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
    end
end

// Generate two clock phases
wire clk_phase1 = (counter < 3'd4);  // 4 cycles high
wire clk_phase2 = (counter > 3'd2);  // 3 cycles high (offset)

// Combine phases to create 3.5x division
assign clk_div = clk_phase1 | clk_phase2;

endmodule