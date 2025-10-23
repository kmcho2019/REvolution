module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Internal signals
reg [2:0] counter;
reg clk_pos, clk_neg;

// Main counter and clock generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
        clk_pos <= 1'b0;
    end else begin
        counter <= (counter == 6) ? 3'b0 : counter + 1;
        clk_pos <= (counter < 4);
    end
end

// Negative edge clock generation
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_neg <= 1'b0;
    end else begin
        clk_neg <= (counter < 3);
    end
end

// Combine the clocks
assign clk_div = clk_pos | clk_neg;

endmodule