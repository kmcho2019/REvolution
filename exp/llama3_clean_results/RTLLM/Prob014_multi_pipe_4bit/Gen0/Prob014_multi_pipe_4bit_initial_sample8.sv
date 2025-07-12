module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output [7:0] mul_out
);

reg [7:0] sum1;
reg [7:0] sum2;
reg [7:0] pp [3:0];

integer i;

always @(*) begin
    for (i = 0; i < 4; i = i + 1) begin
        if (mul_b[i]) begin
            pp[i] = {4'b0, mul_a} << i;
        end else begin
            pp[i] = 8'd0;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum1 <= 8'd0;
    end else begin
        sum1 <= pp[0] + pp[1];
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum2 <= 8'd0;
    end else begin
        sum2 <= sum1 + pp[2] + pp[3];
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 8'd0;
    end else begin
        mul_out <= sum2;
    end
end

endmodule