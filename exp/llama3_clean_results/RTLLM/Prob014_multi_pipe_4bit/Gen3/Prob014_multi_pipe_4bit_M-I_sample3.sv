module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] partial_product;
reg [2*size-1:0] sum;
reg [2*size-1:0] final_sum;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum <= {2*size{1'b0}};
        final_sum <= {2*size{1'b0}};
    end else begin
        sum <= (sum == {2*size{1'b0}})? ((mul_b[0] == 1'b1)? {size{1'b0}} + mul_a : {2*size{1'b0}}) : 
                                             (sum + ((mul_b[1] == 1'b1)? {size{1'b0}} + (mul_a << 1) : {2*size{1'b0}}));
        if (mul_b[2] == 1'b1) begin
            sum <= sum + ({size{1'b0}} + (mul_a << 2));
        end
        if (mul_b[3] == 1'b1) begin
            sum <= sum + ({size{1'b0}} + (mul_a << 3));
        end
        final_sum <= sum;
    end
end

always @(posedge clk) begin
    mul_out <= final_sum;
end

endmodule