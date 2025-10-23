module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] multiplicand;
reg [2*size-1:0] partial_product [size-1:0];
reg [2*size-1:0] sum_reg1;
reg [2*size-1:0] sum_reg2;

integer i;

// Initialize registers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        multiplicand <= {size{1'b0}, mul_a};
        for (i = 0; i < size; i++) begin
            partial_product[i] <= 0;
        end
        sum_reg1 <= 0;
        sum_reg2 <= 0;
    end else begin
        // Generate partial products
        for (i = 0; i < size; i++) begin
            if (mul_b[i] == 1'b1) begin
                partial_product[i] <= multiplicand << i;
            end else begin
                partial_product[i] <= 0;
            end
        end
        
        // Update sum registers
        sum_reg1 <= partial_product[0] + partial_product[1];
        sum_reg2 <= partial_product[2] + partial_product[3];
    end
end

// Update output
always @(posedge clk) begin
    if (rst_n == 1'b1) begin
        mul_out <= sum_reg1 + sum_reg2;
    end else begin
        mul_out <= 0;
    end
end

endmodule