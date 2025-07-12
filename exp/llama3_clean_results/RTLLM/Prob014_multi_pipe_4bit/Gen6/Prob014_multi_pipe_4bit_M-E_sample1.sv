module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

reg [3:0] reg_a;
reg [3:0] reg_b;
reg [7:0] reg_pp [4];
reg [7:0] reg_sum;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_a <= 4'd0;
        reg_b <= 4'd0;
        for (int i = 0; i < 4; i++) begin
            reg_pp[i] <= 8'd0;
        end
        reg_sum <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        reg_a <= mul_a;
        reg_b <= mul_b;
        reg_pp[0] <= (reg_b[0] == 1'b1) ? {4{1'b0}} | reg_a : 8'd0;
        for (int i = 1; i < 4; i++) begin
            reg_pp[i] <= (reg_b[i] == 1'b1) ? {i{1'b0}} | (reg_a << i) : 8'd0;
        end
        reg_sum <= reg_pp[0] + reg_pp[1] + reg_pp[2] + reg_pp[3];
        mul_out <= reg_sum;
    end
end

endmodule