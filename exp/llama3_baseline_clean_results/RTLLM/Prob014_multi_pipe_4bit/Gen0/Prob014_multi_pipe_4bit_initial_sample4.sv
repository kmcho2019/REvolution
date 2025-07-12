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
reg [2*size-1:0] sum;
reg [2*size-1:0] reg1;
reg [2*size-1:0] reg2;

integer i;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg1 <= 0;
        reg2 <= 0;
        mul_out <= 0;
    end else begin
        for (i = 0; i < size; i++) begin
            if (mul_b[i] == 1) begin
                partial_product[i] <= {mul_a, {size{1'b0}}};
            end else begin
                partial_product[i] <= {2*size{1'b0}};
            end
            if (i > 0) begin
                partial_product[i] <= partial_product[i] << i;
            end
        end
        sum <= 0;
        for (i = 0; i < size; i++) begin
            sum <= sum + partial_product[i];
        end
        reg1 <= sum;
        reg2 <= reg1;
        mul_out <= reg2;
    end
end

endmodule