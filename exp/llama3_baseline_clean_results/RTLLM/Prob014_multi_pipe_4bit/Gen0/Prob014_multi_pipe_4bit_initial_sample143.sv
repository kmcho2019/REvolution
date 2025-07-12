module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

reg [7:0] partial_product [3:0];
reg [7:0] sum_reg1 [3:0];
reg [7:0] sum_reg2;

integer i;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (i = 0; i < 4; i++) begin
            partial_product[i] <= 8'd0;
            sum_reg1[i] <= 8'd0;
        end
        sum_reg2 <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        // Generate partial products
        for (i = 0; i < 4; i++) begin
            if (mul_b[i]) begin
                partial_product[i] <= {4'd0, mul_a} << i;
            end else begin
                partial_product[i] <= 8'd0;
            end
        end

        // Add partial products
        for (i = 0; i < 4; i++) begin
            if (i == 0) begin
                sum_reg1[i] <= partial_product[i];
            end else begin
                sum_reg1[i] <= sum_reg1[i-1] + partial_product[i];
            end
        end

        // Final product calculation
        sum_reg2 <= sum_reg1[3];
        mul_out <= sum_reg2;
    end
end

endmodule