module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] reg1;
reg [2*size-1:0] reg2;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg1 <= 'd0;
        reg2 <= 'd0;
        mul_out <= 'd0;
    end else begin
        reg1 <= reg1 + ({size{1'b0}} | mul_a) * ({1'b0} | mul_b);
        reg2 <= reg1;
        mul_out <= reg2;
    end
end

integer i;
reg [2*size-1:0] partial_sum;
always @(*) begin
    partial_sum = 'd0;
    for (i = 0; i < size; i++) begin
        if (mul_b[i] == 1'b1) begin
            partial_sum = partial_sum + ({size{1'b0}} | mul_a) << i;
        end
    end
end

assign reg1 = partial_sum;

endmodule