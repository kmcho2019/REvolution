module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

reg [7:0] reg1;
reg [7:0] reg2;

integer i;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg1 <= 8'd0;
        reg2 <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        reg1 <= 8'd0;
        for (i = 0; i < 4; i = i + 1) begin
            if (mul_b[i]) begin
                reg1 <= reg1 + (mul_a << i);
            end
        end
        reg2 <= reg1;
        mul_out <= reg2;
    end
end

endmodule