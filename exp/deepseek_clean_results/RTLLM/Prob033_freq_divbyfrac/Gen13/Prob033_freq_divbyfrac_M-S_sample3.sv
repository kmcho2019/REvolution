module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// 3-bit counter for 7 cycles (3.5x division)
reg [2:0] counter;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        counter <= 3'b0;
    else
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
end

// Phase clocks (0° and 180°)
reg clk_0, clk_180;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_0 <= 1'b0;
        clk_180 <= 1'b0;
    end else begin
        clk_0 <= (counter == 3'd0) ? ~clk_0 : clk_0;
        clk_180 <= (counter == 3'd3) ? ~clk_180 : clk_180;
    end
end

// Combined output
assign clk_div = clk_0 | clk_180;

endmodule