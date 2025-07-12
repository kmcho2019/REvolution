module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

    reg [7:0] partial_product [3:0];
    reg [7:0] sum_1;
    reg [7:0] sum_2;

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_1 <= 8'd0;
            sum_2 <= 8'd0;
            mul_out <= 8'd0;
        end else begin
            sum_1 <= partial_product[0] + partial_product[1];
            sum_2 <= partial_product[2] + partial_product[3];
            mul_out <= sum_1 + sum_2;
        end
    end

    always @ (*) begin
        for (int i = 0; i < 4; i++) begin
            if (mul_b[i]) begin
                partial_product[i] = {4'd0, mul_a} << i;
            end else begin
                partial_product[i] = 8'd0;
            end
        end
    end

endmodule