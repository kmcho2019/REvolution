module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] partial_sum_reg;
reg [2*size-1:0] final_sum_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        partial_sum_reg <= {2*size{1'b0}};
        final_sum_reg <= {2*size{1'b0}};
    end else begin
        partial_sum_reg <= {2*size{1'b0}};
        for (integer i = 0; i < size; i++) begin
            if (mul_b[i] == 1'b1) begin
                partial_sum_reg <= partial_sum_reg + ({size{1'b0}} | mul_a) << i;
            end
        end
        final_sum_reg <= partial_sum_reg;
    end
end

always @(posedge clk) begin
    mul_out <= final_sum_reg;
end

endmodule