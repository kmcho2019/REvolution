module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output [7:0] mul_out
);

parameter size = 4;

reg [size-1:0] mul_a_ext [size:0];
reg [size-1:0] mul_b_ext [size:0];
reg [2*size-1:0] partial_product [size:0];
reg [2*size-1:0] intermediate_sum [size:0];
reg [2*size-1:0] final_product;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 0; i <= size; i++) begin
            mul_a_ext[i] <= {size{1'b0}};
            mul_b_ext[i] <= {size{1'b0}};
            partial_product[i] <= {2*size{1'b0}};
            intermediate_sum[i] <= {2*size{1'b0}};
        end
        final_product <= {2*size{1'b0}};
    end else begin
        // Extend input signals
        mul_a_ext[0] <= mul_a;
        mul_b_ext[0] <= mul_b;

        // Generate partial products
        for (int i = 0; i < size; i++) begin
            if (mul_b[i] == 1'b1) begin
                partial_product[i+1] <= {mul_a, {size{1'b0}}};
            end else begin
                partial_product[i+1] <= {2*size{1'b0}};
            end
        end

        // Calculate intermediate sums
        for (int i = 1; i <= size; i++) begin
            if (i == 1) begin
                intermediate_sum[i] <= partial_product[i];
            end else begin
                intermediate_sum[i] <= intermediate_sum[i-1] + partial_product[i];
            end
        end

        // Calculate final product
        final_product <= intermediate_sum[size];
    end
end

assign mul_out = final_product;

endmodule