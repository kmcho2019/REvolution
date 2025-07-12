module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

reg [7:0] sum1;
reg [7:0] sum2;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum1 <= 8'd0;
        sum2 <= 8'd0;
        mul_out <= 8'd0;
    end
    else begin
        sum1 <= 8'd0;
        for (int i = 0; i < 4; i++) begin
            if (mul_b[i]) begin
                sum1 <= sum1 + (mul_a << i);
            end
        end
        sum2 <= sum1;
        mul_out <= sum2;
    end
end

endmodule