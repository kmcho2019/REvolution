module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

reg [7:0] partial_product [3:0];
reg [7:0] sum_reg1;
reg [7:0] sum_reg2;

integer i;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg1 <= 8'd0;
        sum_reg2 <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        // Calculate partial products
        for (i = 0; i < size; i++) begin
            if (mul_b[i]) begin
                partial_product[i] <= {mul_a, 4'd0} << i;
            end else begin
                partial_product[i] <= 8'd0;
            end
        end
        
        // Add partial products
        sum_reg1 <= partial_product[0] + partial_product[1];
        sum_reg2 <= partial_product[2] + partial_product[3];
        
        // Final product calculation
        mul_out <= sum_reg1 + sum_reg2;
    end
end

endmodule