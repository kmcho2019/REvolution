module multi_pipe_4bit #(
    parameter size = 4
) (
    input  clk,
    input  rst_n,
    input  [size-1:0] mul_a,
    input  [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

reg [2*size-1:0] partial_product [size];
reg [2*size-1:0] sum_reg;
reg [2*size-1:0] mul_out_reg;

integer i;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (i = 0; i < size; i++) begin
            partial_product[i] <= {2*size{1'b0}};
        end
        sum_reg <= {2*size{1'b0}};
        mul_out_reg <= {2*size{1'b0}};
    end else begin
        for (i = 0; i < size; i++) begin
            if (mul_b[i]) begin
                partial_product[i] <= {size{1'b0}} | (mul_a << i);
            end else begin
                partial_product[i] <= {2*size{1'b0}};
            end
        end
        sum_reg <= {2*size{1'b0}};
        for (i = 0; i < size; i++) begin
            sum_reg <= sum_reg + partial_product[i];
        end
        mul_out_reg <= sum_reg;
    end
end

assign mul_out = mul_out_reg;

endmodule