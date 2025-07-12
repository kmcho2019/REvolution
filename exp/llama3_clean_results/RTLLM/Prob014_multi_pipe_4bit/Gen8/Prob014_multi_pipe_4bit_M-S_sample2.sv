module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] sum_reg1;
reg [2*size-1:0] sum_reg2;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg1 <= {2*size{1'b0}};
        sum_reg2 <= {2*size{1'b0}};
    end else begin
        sum_reg1 <= {2*size{1'b0}};
        for (integer i = 0; i < size; i++) begin
            if (mul_b[i] == 1'b1) begin
                sum_reg1 <= sum_reg1 + ({size{1'b0}, mul_a} << i);
            end
        end
        sum_reg2 <= sum_reg1;
    end
end

always @(posedge clk) begin
    mul_out <= sum_reg2;
end

endmodule