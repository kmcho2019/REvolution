module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg clk_main;
reg clk_comp;

// Double-edge counter (increments on both edges)
always @(posedge clk or negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
    end
end

// Main phase (4 high, 3 low)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_main <= 1'b0;
    end else begin
        clk_main <= (counter < 3'd4);
    end
end

// Complementary phase (3 high, 4 low) - shifted by 180°
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_comp <= 1'b0;
    end else begin
        clk_comp <= (counter < 3'd3);
    end
end

// Combine both phases
assign clk_div = clk_main | clk_comp;

endmodule