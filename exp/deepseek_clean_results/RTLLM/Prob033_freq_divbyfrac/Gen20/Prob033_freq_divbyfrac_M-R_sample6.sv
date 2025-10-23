module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg clk_a, clk_b;

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1;
    end
end

// Phase A generation (toggles at counter == 3)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_a <= 1'b0;
    end else if (counter == 3'd3) begin
        clk_a <= ~clk_a;
    end
end

// Phase B generation (inverted and delayed version of clk_a)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_b <= 1'b0;
    end else begin
        clk_b <= ~clk_a;
    end
end

// Combined output using XOR
assign clk_div = clk_a ^ clk_b;

endmodule