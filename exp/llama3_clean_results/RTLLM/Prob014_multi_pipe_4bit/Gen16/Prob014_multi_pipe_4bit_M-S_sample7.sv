module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] stage1_reg;
reg [2*size-1:0] stage2_reg;

// Input stage
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_reg <= {2*size{1'b0}};
        stage2_reg <= {2*size{1'b0}};
        mul_out <= {2*size{1'b0}};
    end else begin
        stage1_reg <= {size{1'b0}, mul_a};
        stage2_reg <= {2*size{1'b0}};
    end
end

// Partial product generation and accumulation stage
wire [2*size-1:0] partial_sum1;
wire [2*size-1:0] partial_sum2;

assign partial_sum1 = {2*size{1'b0}};
assign partial_sum2 = {2*size{1'b0}};

always @(*) begin
    partial_sum1 = {2*size{1'b0}};
    partial_sum2 = {2*size{1'b0}};
    for (int i = 0; i < size; i++) begin
        if (mul_b[i] == 1'b1) begin
            partial_sum1 = partial_sum1 + ({size{1'b0}, mul_a} << i);
        end
    end
end

// Pipeline registers
always @(posedge clk) begin
    stage2_reg <= partial_sum1;
end

// Output stage
always @(posedge clk) begin
    mul_out <= stage2_reg;
end

endmodule