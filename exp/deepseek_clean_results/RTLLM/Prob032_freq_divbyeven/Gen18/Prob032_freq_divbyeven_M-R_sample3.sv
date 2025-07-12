module freq_diveven (
    input clk,
    input rst_n,
    output clk_div
);

parameter NUM_DIV = 4;  // Division factor (must be even)

// Validate parameter (synthesis-time check)
initial begin
    if (NUM_DIV[0] || NUM_DIV < 2) begin
        $error("NUM_DIV must be an even number >= 2");
    end
end

reg [3:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
    end
    else begin
        cnt <= (cnt == (NUM_DIV - 1)) ? 0 : cnt + 1;
    end
end

// Output clock toggles when counter passes midpoint
assign clk_div = cnt < (NUM_DIV / 2) ? 1'b0 : 1'b1;

endmodule