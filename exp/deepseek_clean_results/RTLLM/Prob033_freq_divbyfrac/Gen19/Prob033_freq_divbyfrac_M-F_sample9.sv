module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg clk_div1, clk_div2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
        clk_div1 <= 1'b0;
    end else begin
        // Update counter (0-6)
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
        
        // Generate first intermediate clock (0° phase)
        if (counter < 3'd4) begin
            clk_div1 <= 1'b1;  // First period: 4 cycles high
        end else begin
            clk_div1 <= 1'b0;  // First period: 3 cycles low
        end
    end
end

always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div2 <= 1'b0;
    end else begin
        // Generate second intermediate clock (180° phase shifted)
        if (counter < 3'd3 || counter == 3'd6) begin
            clk_div2 <= 1'b1;
        end else begin
            clk_div2 <= 1'b0;
        end
    end
end

// Combine both phase-shifted clocks
assign clk_div = clk_div1 | clk_div2;

endmodule