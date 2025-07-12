module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output [7:0] mul_out
);

reg [7:0] intermediate1;
reg [7:0] intermediate2;

assign mul_out = intermediate2;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        intermediate1 <= 8'd0;
        intermediate2 <= 8'd0;
    end else begin
        intermediate1 <= {4'd0, mul_a} * (mul_b[0] ? 1 : 0);
        if (mul_b[1]) begin
            intermediate1 <= {4'd0, mul_a} << 1;
        end
        if (mul_b[2]) begin
            intermediate1 <= {4'd0, mul_a} << 2;
        end
        if (mul_b[3]) begin
            intermediate1 <= {4'd0, mul_a} << 3;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        intermediate2 <= 8'd0;
    end else begin
        if (mul_b[1]) begin
            intermediate2 <= intermediate1 + ({4'd0, mul_a} << 1);
        end
        if (mul_b[2]) begin
            intermediate2 <= intermediate1 + ({4'd0, mul_a} << 2);
        end
        if (mul_b[3]) begin
            intermediate2 <= intermediate1 + ({4'd0, mul_a} << 3);
        end
        intermediate2 <= intermediate1;
    end
end

endmodule