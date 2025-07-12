module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output [7:0] mul_out
);

reg [7:0] partial_product [3:0];
reg [7:0] sum_reg [1:0];
reg [7:0] mul_out_reg;

integer i;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (i = 0; i < 4; i++) begin
            partial_product[i] <= 8'b0;
        end
        sum_reg[0] <= 8'b0;
        sum_reg[1] <= 8'b0;
        mul_out_reg <= 8'b0;
    end else begin
        // Extension of input signals
        for (i = 0; i < 4; i++) begin
            if (mul_b[i]) begin
                partial_product[i] <= {4'b0, mul_a} << i;
            end else begin
                partial_product[i] <= 8'b0;
            end
        end

        // Add of partial products
        sum_reg[0] <= partial_product[0] + partial_product[1];
        sum_reg[1] <= partial_product[2] + partial_product[3];

        // Final product calculation
        mul_out_reg <= sum_reg[0] + sum_reg[1];
    end
end

assign mul_out = mul_out_reg;

endmodule