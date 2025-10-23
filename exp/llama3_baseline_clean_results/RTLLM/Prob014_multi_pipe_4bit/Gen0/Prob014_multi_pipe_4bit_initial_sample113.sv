module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

reg [2*size-1:0] reg1;
reg [2*size-1:0] reg2;
reg [2*size-1:0] partial_product;

integer i;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg1 <= 'd0;
        reg2 <= 'd0;
    end else begin
        reg1 <= 'd0;
        for (i = 0; i < size; i++) begin
            if (mul_b[i]) begin
                partial_product = {size'd0, mul_a} << i;
                reg1 <= reg1 + partial_product;
            end
        end
        reg2 <= reg1;
    end
end

assign mul_out = reg2;

endmodule