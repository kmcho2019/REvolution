module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output [7:0] mul_out
);

reg [7:0] partial_product [3:0];
reg [7:0] sum_reg;
reg [7:0] final_product_reg;

integer i;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg <= 8'd0;
        final_product_reg <= 8'd0;
        for (i = 0; i < 4; i++) begin
            partial_product[i] <= 8'd0;
        end
    end else begin
        // Generate partial products for each bit position of the multiplier
        for (i = 0; i < 4; i++) begin
            if (mul_b[i]) begin
                partial_product[i] <= {4'd0, mul_a} << i;
            end else begin
                partial_product[i] <= 8'd0;
            end
        end

        // Add partial products
        sum_reg <= partial_product[0] + partial_product[1] + partial_product[2] + partial_product[3];

        // Update final product
        final_product_reg <= sum_reg;
    end
end

assign mul_out = final_product_reg;

endmodule