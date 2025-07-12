module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
    end
end

// Generate two clock phases with different duty cycles
wire clk_phase1 = (counter < 3'd4);  // 4 cycles high
wire clk_phase2 = (counter > 3'd3);  // 3 cycles high

// Combine phases to create 3.5x divided clock
assign clk_div = clk_phase1 | clk_phase2;

endmodule