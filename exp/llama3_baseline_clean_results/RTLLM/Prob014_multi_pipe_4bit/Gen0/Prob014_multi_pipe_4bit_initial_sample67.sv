module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

    parameter size = 4;

    reg [7:0] partial_product;
    reg [7:0] intermediate_sum;
    reg [7:0] sum_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_reg <= 8'd0;
            mul_out <= 8'd0;
        end else begin
            sum_reg <= intermediate_sum;
            mul_out <= sum_reg;
        end
    end

    always @(*) begin
        partial_product = 8'd0;
        for (int i = 0; i < size; i++) begin
            if (mul_b[i] == 1'b1) begin
                partial_product = partial_product + (mul_a << i);
            end
        end
        intermediate_sum = partial_product;
    end

    reg [7:0] temp;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            temp <= 8'd0;
        end else begin
            temp <= intermediate_sum;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            intermediate_sum <= 8'd0;
        end else begin
            intermediate_sum <= temp;
        end
    end

endmodule