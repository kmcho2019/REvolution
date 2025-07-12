module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output [7:0] mul_out
);

    reg [7:0] partial_product [3:0];
    reg [7:0] sum_reg1;
    reg [7:0] sum_reg2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_reg1 <= 8'd0;
            sum_reg2 <= 8'd0;
        end else begin
            sum_reg1 <= partial_product[0] + (mul_b[0] ? (mul_a << 0) : 8'd0);
            sum_reg2 <= sum_reg1;
        end
    end

    integer i;
    generate
        for (i = 1; i < 4; i++) begin
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    partial_product[i] <= 8'd0;
                end else begin
                    partial_product[i] <= (mul_b[i] ? (mul_a << i) : 8'd0) + sum_reg2;
                end
            end
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 8'd0;
        end else begin
            mul_out <= partial_product[3];
        end
    end

endmodule