module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

reg [2:0] counter;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
        clk_div <= 1'b0;
    end else begin
        // Increment counter (0-6)
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
        
        // Generate divided clock (high for 4 cycles, low for 3)
        clk_div <= (counter < 3'd4);
    end
end

endmodule