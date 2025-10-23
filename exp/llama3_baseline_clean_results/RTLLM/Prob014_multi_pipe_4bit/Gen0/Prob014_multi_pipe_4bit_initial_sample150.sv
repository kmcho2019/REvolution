module multi_pipe_4bit #(
    parameter size = 4
) (
    input           clk,
    input           rst_n,
    input  [size-1:0] mul_a,
    input  [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

reg [2*size-1:0] partial_product [size-1:0];
reg [2*size-1:0] sum;
reg [2*size-1:0] product;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum <= 0;
        product <= 0;
    end else begin
        // Generate partial products
        for (int i = 0; i < size; i++) begin
            if (mul_b[i]) begin
                partial_product[i] <= {size{1'b0}} << i;
            end else begin
                partial_product[i] <= 0;
            end
        end
        
        // Calculate sum of partial products
        sum <= sum + mul_a;
        
        // Calculate final product
        product <= sum;
    end
end

assign mul_out = product;

endmodule