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
reg [2*size-1:0] final_product_reg;
reg [2*size-1:0] extended_mul_a;

assign extended_mul_a = {size{1'b0}} | mul_a; // Extend mul_a with size zeros

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        partial_sum_reg <= {2*size{1'b0}};
        final_product_reg <= {2*size{1'b0}};
    end else begin
        reg [2*size-1:0] temp_sum;
        temp_sum = {2*size{1'b0}};
        for (int i = 0; i < size; i++) begin
            if (mul_b[i] == 1'b1) begin
                temp_sum = temp_sum + (extended_mul_a << i);
            end
        end
        partial_sum_reg <= temp_sum;
        final_product_reg <= partial_sum_reg;
    end
end

always @(posedge clk) begin
    mul_out <= final_product_reg;
end

endmodule