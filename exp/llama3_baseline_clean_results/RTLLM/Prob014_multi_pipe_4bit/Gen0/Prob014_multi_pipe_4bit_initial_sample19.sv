module multi_pipe_4bit #(
    parameter size = 4
) (
    input               clk,
    input               rst_n,
    input  [size-1:0]    mul_a,
    input  [size-1:0]    mul_b,
    output [2*size-1:0]  mul_out
);

reg [2*size-1:0] partial_products [size-1:0];
reg [2*size-1:0] sum;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 0; i < size; i++) begin
            partial_products[i] <= 'd0;
        end
        sum <= 'd0;
        mul_out <= 'd0;
    end else begin
        // Generate partial products
        for (int i = 0; i < size; i++) begin
            if (mul_b[i]) begin
                partial_products[i] <= {size{1'b0}} << i;
            end else begin
                partial_products[i] <= 'd0;
            end
        end
        
        // Perform add operation
        sum <= 'd0;
        for (int i = 0; i < size; i++) begin
            sum <= sum + (partial_products[i] * { {size{1'b0}}, mul_a });
        end
        
        // Calculate final product
        mul_out <= sum;
    end
end

endmodule