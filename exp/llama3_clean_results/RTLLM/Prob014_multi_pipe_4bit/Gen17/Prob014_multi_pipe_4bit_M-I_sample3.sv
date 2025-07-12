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
reg [2*size-1:0] sum;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 0; i < size; i++) begin
            partial_products[i] <= {2*size{1'b0}};
        end
        sum <= {2*size{1'b0}};
        mul_out <= {2*size{1'b0}};
    end else begin
        // Generate partial products in parallel
        for (int i = 0; i < size; i++) begin
            if (mul_b[i] == 1'b1) begin
                partial_products[i] <= mul_a << i;
            end else begin
                partial_products[i] <= {2*size{1'b0}};
            end
        end
        
        // Sum the partial products
        sum <= {2*size{1'b0}};
        for (int i = 0; i < size; i++) begin
            sum <= sum + partial_products[i];
        end
        
        // Update the output
        mul_out <= sum;
    end
end

endmodule