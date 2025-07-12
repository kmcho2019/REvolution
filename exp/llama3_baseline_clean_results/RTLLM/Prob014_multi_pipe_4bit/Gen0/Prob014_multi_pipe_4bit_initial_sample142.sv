module multi_pipe_4bit (
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

// Generate partial products
genvar i;
generate
    for (i = 0; i < size; i = i + 1) begin
        always @(mul_a, mul_b) begin
            if (mul_b[i] == 1) begin
                partial_product[i] = {4'b0, mul_a} << i;
            end else begin
                partial_product[i] = 8'b0;
            end
        end
    end
endgenerate

// First level of registers
always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        sum_reg1 <= 8'b0;
    end else begin
        sum_reg1 <= partial_product[0] + partial_product[1] + partial_product[2] + partial_product[3];
    end
end

// Second level of registers
always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        sum_reg2 <= 8'b0;
    end else begin
        sum_reg2 <= sum_reg1;
    end
end

// Final product calculation
always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 8'b0;
    end else begin
        mul_out <= sum_reg2;
    end
end

endmodule