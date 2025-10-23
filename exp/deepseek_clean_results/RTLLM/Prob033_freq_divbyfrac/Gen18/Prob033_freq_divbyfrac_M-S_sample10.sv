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
        // Update counter (0-6)
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
        
        // Generate divided clock
        if (counter < 3'd4) begin
            clk_div <= 1'b1;  // First period: 4 cycles high
        end else begin
            clk_div <= 1'b0;  // First period: 3 cycles low
        end
    end
end

endmodule