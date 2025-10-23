module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

reg [2:0] counter;  // 0-6 counter for 3.5x division

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
        clk_div <= 1'b0;
    end else begin
        // Update counter (0-6)
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
        
        // Generate divided clock (high for counts 0-3, low for 4-6)
        clk_div <= (counter <= 3'd3) ? 1'b1 : 1'b0;
    end
end

endmodule