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
reg [2*size-1:0] sum_reg_pipe;

// Calculate partial products
genvar i;
generate
    for (i = 0; i < size; i++) begin
        always @(posedge clk or negedge rst_n) begin
            if (~rst_n) begin
                partial_products[i] <= {2*size{1'b0}};
            end else if (mul_b[i] == 1'b1) begin
                partial_products[i] <= {size-i{1'b0}, mul_a, i{1'b0}};
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
        sum_reg_pipe <= {2*size{1'b0}};
    end else begin
        reg [2*size-1:0] temp_sum;
        temp_sum = {2*size{1'b0}};
        for (int j = 0; j < size; j++) begin
            temp_sum = temp_sum + partial_products[j];
        end
        sum_reg <= temp_sum;
        sum_reg_pipe <= sum_reg;
    end
end

// Update output
always @(posedge clk) begin
    if (~rst_n) begin
        mul_out <= {2*size{1'b0}};
    end else begin
        mul_out <= sum_reg_pipe;
    end
end

endmodule