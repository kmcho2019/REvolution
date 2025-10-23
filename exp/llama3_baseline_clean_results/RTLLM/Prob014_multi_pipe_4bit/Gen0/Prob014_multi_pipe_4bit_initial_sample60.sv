module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

reg [7:0] reg1;
reg [7:0] reg2;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg1 <= 8'd0;
        reg2 <= 8'd0;
    end else begin
        reg1 <= {4'd0, mul_a} * mul_b[0] + {5'd0, mul_a} * mul_b[1] + {6'd0, mul_a} * mul_b[2] + {7'd0, mul_a} * mul_b[3];
        reg2 <= reg1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= 8'd0;
    end else begin
        mul_out <= reg2;
    end
end

endmodule