module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] partial_product [size-1:0];
reg [2*size-1:0] sum_reg1;
reg [2*size-1:0] sum_reg2;

integer i;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (i = 0; i < size; i++) begin
            partial_product[i] <= 0;
        end
        sum_reg1 <= 0;
        sum_reg2 <= 0;
        mul_out <= 0;
    end else begin
        // Generate partial products
        for (i = 0; i < size; i++) begin
            if (mul_b[i]) begin
                partial_product[i] <= { {size{1'b0}}, mul_a } << i;
            end else begin
                partial_product[i] <= 0;
            end
        end
        
        // First level of add operation
        sum_reg1 <= partial_product[0];
        for (i = 1; i < size; i++) begin
            if (i == 1) begin
                sum_reg1 <= partial_product[0] + partial_product[1];
            end else begin
                sum_reg1 <= sum_reg1 + partial_product[i];
            end
        end
        
        // Second level of add operation
        sum_reg2 <= sum_reg1;
        
        // Final product calculation
        mul_out <= sum_reg2;
    end
end

endmodule