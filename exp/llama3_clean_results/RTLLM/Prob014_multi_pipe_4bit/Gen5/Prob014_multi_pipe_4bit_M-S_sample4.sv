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
        reg1 <= 0;
        reg2 <= 0;
        mul_out <= 0;
    end else begin
        reg1 <= (mul_b[0]? mul_a : 0) + 
                 (mul_b[1]? (mul_a << 1) : 0) + 
                 (mul_b[2]? (mul_a << 2) : 0) + 
                 (mul_b[3]? (mul_a << 3) : 0);
        reg2 <= reg1;
        mul_out <= reg2;
    end
end

endmodule