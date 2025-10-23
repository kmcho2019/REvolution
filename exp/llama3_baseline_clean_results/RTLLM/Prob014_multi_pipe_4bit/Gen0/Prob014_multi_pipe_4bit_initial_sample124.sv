module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

reg [7:0] partial_product [3:0];
reg [7:0] reg1 [3:0];
reg [7:0] reg2;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg2 <= 8'd0;
    end else begin
        reg2 <= reg1[0];
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 0; i < 4; i++) begin
            reg1[i] <= 8'd0;
        end
    end else begin
        for (int i = 0; i < 3; i++) begin
            reg1[i] <= reg1[i + 1];
        end
        reg1[3] <= 8'd0;
        for (int i = 0; i < 4; i++) begin
            if (mul_b[i]) begin
                partial_product[i] <= {4'd0, mul_a} << i;
            end else begin
                partial_product[i] <= 8'd0;
            end
        end
        reg1[3] <= partial_product[0];
        for (int i = 1; i < 4; i++) begin
            reg1[i] <= reg1[i] + partial_product[i];
        end
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