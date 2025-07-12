module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

reg [2*size-1:0] partial_sum1;
reg [2*size-1:0] partial_sum2;

integer i;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        partial_sum1 <= 'd0;
        partial_sum2 <= 'd0;
    end else begin
        partial_sum1 <= 'd0;
        for (i = 0; i < size; i = i + 1) begin
            if (mul_b[i]) begin
                partial_sum1 <= partial_sum1 + ({size{1'b0}}, mul_a) << i;
            end
        end
        partial_sum2 <= partial_sum1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 'd0;
    end else begin
        mul_out <= partial_sum2;
    end
end

endmodule