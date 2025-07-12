module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

reg [2:0] cycle_count;  // Counts 0-6 (7 cycles total)

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cycle_count <= 3'b0;
        clk_div <= 1'b0;
    end else begin
        // Update counter (0-6)
        cycle_count <= (cycle_count == 3'd6) ? 3'b0 : cycle_count + 1;
        
        // Generate output clock (high for 4 cycles, low for 3)
        clk_div <= (cycle_count < 3'd4) ? 1'b1 : 1'b0;
    end
end

endmodule