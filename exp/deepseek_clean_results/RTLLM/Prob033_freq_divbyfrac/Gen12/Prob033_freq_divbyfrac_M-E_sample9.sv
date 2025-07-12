module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] cnt_a, cnt_b;
reg clk_a, clk_b;

// Counter A (4-cycle division)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_a <= 3'b0;
        clk_a <= 1'b0;
    end else begin
        if (cnt_a == 3'd3) begin
            cnt_a <= 3'b0;
            clk_a <= ~clk_a;
        end else begin
            cnt_a <= cnt_a + 1;
        end
    end
end

// Counter B (3-cycle division, 180° phase shifted)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_b <= 3'b0;
        clk_b <= 1'b0;
    end else begin
        if (cnt_b == 3'd2) begin
            cnt_b <= 3'b0;
            clk_b <= ~clk_b;
        end else begin
            cnt_b <= cnt_b + 1;
        end
    end
end

// XOR combination for precise fractional division
assign clk_div = clk_a ^ clk_b;

endmodule