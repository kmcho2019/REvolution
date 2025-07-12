module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// 3.5x division requires 7 states (0-6)
reg [2:0] counter;

// Phase clocks
reg clk_0;
reg clk_180;

// Main counter (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
    end
end

// 0° phase clock (high for first 4 counts)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_0 <= 1'b0;
    end else begin
        clk_0 <= (counter < 3'd4);
    end
end

// 180° phase clock (same pattern but delayed half cycle)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_180 <= 1'b0;
    end else begin
        clk_180 <= (counter < 3'd4);
    end
end

// Combined output
assign clk_div = clk_0 | clk_180;

endmodule