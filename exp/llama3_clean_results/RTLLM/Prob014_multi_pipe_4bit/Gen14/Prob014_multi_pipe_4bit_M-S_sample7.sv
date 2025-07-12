module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] reg_a;
reg [2*size-1:0] reg_b;
reg [2*size-1:0] reg_sum;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_a <= 0;
        reg_b <= 0;
        reg_sum <= 0;
    end else begin
        reg_a <= {size{1'b0}, mul_a};
        reg_b <= {size{1'b0}, mul_b};
        reg_sum <= 0;
        
        for (int i = 0; i < size; i++) begin
            if (mul_b[i] == 1'b1) begin
                reg_sum <= reg_sum + (mul_a << i);
            end
        end
        
        mul_out <= reg_sum;
    end
end

endmodule