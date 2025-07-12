module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg clk_div1, clk_div2;

// Positive edge triggered logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
        clk_div1 <= 1'b0;
    end else begin
        // Cycle counter (0-6)
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
        
        // Generate base pattern (high for 4 cycles, low for 3)
        clk_div1 <= (counter < 3'd4);
    end
end

// Negative edge triggered logic for phase shift
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div2 <= 1'b0;
    end else begin
        // Sample the counter value to create half-cycle delayed version
        clk_div2 <= (counter < 3'd4);
    end
end

// OR combination creates fractional division
assign clk_div = clk_div1 | clk_div2;

endmodule