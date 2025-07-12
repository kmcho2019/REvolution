module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] partial_product [size-1:0];
reg [2*size-1:0] sum_reg1;
reg [2*size-1:0] sum_reg2;

integer i;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (i = 0; i < size; i++) begin
            partial_product[i] <= {size{1'b0}};
        end
        sum_reg1 <= {2*size{1'b0}};
        sum_reg2 <= {2*size{1'b0}};
        mul_out <= {2*size{1'b0}};
    end else begin
        for (i = 0; i < size; i++) begin
            if (mul_b[i]) begin
                partial_product[i] <= {size{1'b0}} << i | mul_a;
            end else begin
                partial_product[i] <= {2*size{1'b0}};
            end
        end
        sum_reg1 <= {2*size{1'b0}};
        for (i = 0; i < size/2; i++) begin
            sum_reg1 <= sum_reg1 + partial_product[i];
        end
        sum_reg2 <= sum_reg1;
        for (i = size/2; i < size; i++) begin
            sum_reg2 <= sum_reg2 + partial_product[i];
        end
        mul_out <= sum_reg2;
    end
end

endmodule