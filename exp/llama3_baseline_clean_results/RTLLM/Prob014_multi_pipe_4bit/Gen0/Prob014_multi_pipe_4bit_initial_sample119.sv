module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

reg [2*size-1:0] partial_products [size-1:0];
reg [2*size-1:0] sum_reg1;
reg [2*size-1:0] sum_reg2;
reg [2*size-1:0] mul_out_reg;

integer i;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < size; i++) begin
            partial_products[i] <= {size{1'b0}};
        end
        sum_reg1 <= {2*size{1'b0}};
        sum_reg2 <= {2*size{1'b0}};
        mul_out_reg <= {2*size{1'b0}};
    end else begin
        for (i = 0; i < size; i++) begin
            if (mul_b[i]) begin
                partial_products[i] <= {size{1'b0}, mul_a} << i;
            end else begin
                partial_products[i] <= {size{1'b0}};
            end
        end
        sum_reg1 <= partial_products[0];
        for (i = 1; i < size; i++) begin
            sum_reg2 <= sum_reg1 + partial_products[i];
            sum_reg1 <= sum_reg2;
        end
        mul_out_reg <= sum_reg2;
    end
end

assign mul_out = mul_out_reg;

endmodule