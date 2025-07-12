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
reg [2*size-1:0] sum_registers [size-1:0];

integer i;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (i = 0; i < size; i++) begin
            partial_products[i] <= 0;
            sum_registers[i] <= 0;
        end
        mul_out <= 0;
    end else begin
        // Calculate partial products
        for (i = 0; i < size; i++) begin
            if (mul_b[i]) begin
                partial_products[i] <= {mul_a, {size{1'b0}}} << i;
            end else begin
                partial_products[i] <= 0;
            end
        end
        
        // Store sum of partial products in first level of registers
        sum_registers[0] <= partial_products[0];
        for (i = 1; i < size; i++) begin
            sum_registers[i] <= sum_registers[i-1] + partial_products[i];
        end
        
        // Calculate final product
        mul_out <= sum_registers[size-1];
    end
end

endmodule