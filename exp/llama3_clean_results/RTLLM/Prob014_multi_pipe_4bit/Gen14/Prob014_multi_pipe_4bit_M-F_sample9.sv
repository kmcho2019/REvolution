module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Register to store the intermediate sum
reg [2*size-1:0] sum_reg;
// Register to store the final product
reg [2*size-1:0] product_reg;

// Reset logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg <= {2*size{1'b0}};
        product_reg <= {2*size{1'b0}};
        mul_out <= {2*size{1'b0}};
    end else begin
        // First clock cycle: calculate partial products and accumulate sum
        sum_reg <= {2*size{1'b0}};
        for (int i = 0; i < size; i++) begin
            if (mul_b[i] == 1'b1) begin
                sum_reg <= sum_reg + ({mul_a, {size{1'b0}}} << i);
            end
        end
        // Second clock cycle: calculate final product
        product_reg <= sum_reg;
        mul_out <= product_reg;
    end
end

endmodule