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
        reg1 <= calculate_partial_sum(mul_a, mul_b);
        reg2 <= reg1;
        mul_out <= reg2;
    end
end

function [2*size-1:0] calculate_partial_sum;
    input [size-1:0] a;
    input [size-1:0] b;
    reg [2*size-1:0] sum;
    integer i;
    begin
        sum = 'd0;
        for (i = 0; i < size; i++) begin
            if (b[i] == 1'b1) begin
                sum = sum + ({size{1'b0}} | a) << i;
            end
        end
        calculate_partial_sum = sum;
    end
endfunction

endmodule