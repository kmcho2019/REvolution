module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output [7:0] mul_out
);

    reg [7:0] partial_products [3:0];
    reg [7:0] sum_reg1;
    reg [7:0] sum_reg2;

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            for (i = 0; i < 4; i++) begin
                partial_products[i] <= 8'd0;
            end
            sum_reg1 <= 8'd0;
            sum_reg2 <= 8'd0;
            mul_out <= 8'd0;
        end else begin
            // Generate partial products
            for (i = 0; i < 4; i++) begin
                if (mul_b[i]) begin
                    partial_products[i] <= {4'd0, mul_a} << i;
                end else begin
                    partial_products[i] <= 8'd0;
                end
            end

            // Calculate sum of partial products
            sum_reg1 <= partial_products[0] + partial_products[1];
            sum_reg2 <= partial_products[2] + partial_products[3];

            // Calculate final product
            mul_out <= sum_reg1 + sum_reg2;
        end
    end

endmodule