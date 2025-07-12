module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

reg [7:0] partial_product [3:0];
reg [7:0] intermediate_sum [3:0];
reg [7:0] final_sum;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < 4; i++) begin
            partial_product[i] <= 8'd0;
            intermediate_sum[i] <= 8'd0;
        end
        final_sum <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        // Generate partial products
        for (int i = 0; i < 4; i++) begin
            if (mul_b[i]) begin
                partial_product[i] <= {4'd0, mul_a} << i;
            end else begin
                partial_product[i] <= 8'd0;
            end
        end

        // Store intermediate sum values
        intermediate_sum[0] <= partial_product[0];
        for (int i = 1; i < 4; i++) begin
            intermediate_sum[i] <= intermediate_sum[i-1] + partial_product[i];
        end

        // Calculate final product
        final_sum <= intermediate_sum[3];

        // Output final product
        mul_out <= final_sum;
    end
end

endmodule