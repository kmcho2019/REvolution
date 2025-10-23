module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg clk_div1, clk_div2;

// 7-cycle counter (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
    end
end

// Base clock (high for 4 cycles)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div1 <= 1'b0;
    end else begin
        clk_div1 <= (counter < 3'd4);
    end
end

// Phase-shifted clock (delayed by 1 cycle)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div2 <= 1'b0;
    end else begin
        clk_div2 <= (counter > 3'd0) && (counter < 3'd5);
    end
end

// Final output
assign clk_div = clk_div1 | clk_div2;

endmodule