module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] partial_product;
reg [2*size-1:0] sum;
reg [2*size-1:0] sum_next;

integer i;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum <= 'd0;
        mul_out <= 'd0;
    end else begin
        sum <= sum_next;
        mul_out <= sum;
    end
end

always @(*) begin
    sum_next = 'd0;
    for (i = 0; i < size; i++) begin
        if (mul_b[i]) begin
            partial_product = {size'd0, mul_a} << i;
        end else begin
            partial_product = 'd0;
        end
        sum_next = sum_next + partial_product;
    end
end

endmodule