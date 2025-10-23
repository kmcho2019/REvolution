module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Generate and sum partial products combinatorially
wire [2*size-1:0] partial_sum = 
    (mul_b[0] ? {{size{1'b0}}, mul_a} : 0) +
    (mul_b[1] ? {{size-1{1'b0}}, mul_a, 1'b0} : 0) +
    (mul_b[2] ? {{size-2{1'b0}}, mul_a, 2'b0} : 0) +
    (mul_b[3] ? {{size-3{1'b0}}, mul_a, 3'b0} : 0);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 0;
    end else begin
        mul_out <= partial_sum;
    end
end

endmodule