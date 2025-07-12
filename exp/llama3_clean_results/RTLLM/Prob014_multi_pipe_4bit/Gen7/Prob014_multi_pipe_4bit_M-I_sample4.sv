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
reg [2*size-1:0] final_sum_reg;

genvar i;
integer j;

// Calculate partial products
generate
    for (i = 0; i < size; i++) begin
        always @(posedge clk or negedge rst_n) begin
            if (~rst_n) begin
                partial_products[i] <= {2*size{1'b0}};
            end else if (mul_b[i] == 1'b1) begin
                partial_products[i] <= {size{1'b0}, mul_a} << i;
            end else begin
                partial_products[i] <= {2*size{1'b0}};
            end
        end
    end
endgenerate

// Calculate sum
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg <= {2*size{1'b0}};
        final_sum_reg <= {2*size{1'b0}};
    end else begin
        sum_reg <= {2*size{1'b0}};
        for (j = 0; j < size; j++) begin
            sum_reg <= sum_reg + partial_products[j];
        end
        final_sum_reg <= sum_reg;
    end
end

// Update output
always @(posedge clk) begin
    if (~rst_n) begin
        mul_out <= {2*size{1'b0}};
    end else begin
        mul_out <= final_sum_reg;
    end
end

endmodule