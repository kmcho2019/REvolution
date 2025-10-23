module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] partial_products [size-1:0];
reg [2*size-1:0] sum_reg;

genvar gen_i;
generate
    for (gen_i = 0; gen_i < size; gen_i++) begin
        always @(posedge clk or negedge rst_n) begin
            if (~rst_n) begin
                partial_products[gen_i] <= {2*size{1'b0}};
            end else if (mul_b[gen_i] == 1'b1) begin
                partial_products[gen_i] <= {size{1'b0}, mul_a} << gen_i;
            end else begin
                partial_products[gen_i] <= {2*size{1'b0}};
            end
        end
    end
endgenerate

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg <= {2*size{1'b0}};
    end else begin
        sum_reg <= {2*size{1'b0}};
        for (integer i = 0; i < size; i++) begin
            sum_reg <= sum_reg + partial_products[i];
        end
    end
end

always @(posedge clk) begin
    mul_out <= sum_reg;
end

endmodule