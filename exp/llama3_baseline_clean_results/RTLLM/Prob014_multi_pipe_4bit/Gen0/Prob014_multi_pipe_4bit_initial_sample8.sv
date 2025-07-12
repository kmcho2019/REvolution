module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

    reg [7:0] partial_product [3:0];
    reg [7:0] sum1, sum2;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            sum1 <= 8'd0;
            sum2 <= 8'd0;
            mul_out <= 8'd0;
        end else begin
            // Calculate partial products
            for (int i = 0; i < 4; i++) begin
                if (mul_b[i] == 1'b1) begin
                    partial_product[i] <= {4'd0, mul_a} << i;
                end else begin
                    partial_product[i] <= 8'd0;
                end
            end

            // Add partial products
            sum1 <= partial_product[0] + partial_product[1];
            sum2 <= partial_product[2] + partial_product[3];

            // Calculate final product
            mul_out <= sum1 + sum2;
        end
    end

endmodule