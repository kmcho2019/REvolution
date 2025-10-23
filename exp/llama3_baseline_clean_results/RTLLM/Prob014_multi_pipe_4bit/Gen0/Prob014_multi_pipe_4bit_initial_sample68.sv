module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

localparam size = 4;

reg [7:0] stage1_out;
reg [7:0] stage2_out;

// Stage 1: Multiplication and addition of partial products
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_out <= 8'd0;
    end else begin
        reg [7:0] partial_product;
        partial_product = 8'd0;
        for (int i = 0; i < size; i++) begin
            if (mul_b[i]) begin
                partial_product = partial_product + (mul_a << i);
            end
        end
        stage1_out <= partial_product;
    end
end

// Stage 2: Final product calculation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage2_out <= 8'd0;
    end else begin
        stage2_out <= stage1_out;
    end
end

// Output
always @(*) begin
    mul_out = stage2_out;
end

endmodule