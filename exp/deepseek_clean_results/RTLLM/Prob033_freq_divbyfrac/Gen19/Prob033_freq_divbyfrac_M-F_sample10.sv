module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg clk_div1, clk_div2;
reg clk_div2_delayed;

// Single-edge counter (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
    end
end

// Base divided clock (high for 4 cycles: states 0-3)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div1 <= 1'b0;
    end else begin
        clk_div1 <= (counter <= 3'd3);
    end
end

// Phase-shifted clock (high for 3 cycles: states 4-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div2 <= 1'b0;
    end else begin
        clk_div2 <= (counter >= 3'd4);
    end
end

// Half-cycle delay for phase alignment
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div2_delayed <= 1'b0;
    end else begin
        clk_div2_delayed <= clk_div2;
    end
end

// Final output combines both phases
assign clk_div = clk_div1 | clk_div2_delayed;

endmodule