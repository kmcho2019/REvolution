module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

    reg [7:0] reg1;
    reg [7:0] reg2;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            reg1 <= 8'd0;
            reg2 <= 8'd0;
        end
        else begin
            reg1 <= {4'd0, mul_a};
            reg2 <= reg1;
        end
    end

    reg [7:0] partial_product [3:0];

    generate
        for (genvar i = 0; i < 4; i = i + 1) begin
            always @(posedge clk or negedge rst_n) begin
                if (~rst_n) begin
                    partial_product[i] <= 8'd0;
                end
                else if (mul_b[i]) begin
                    partial_product[i] <= {4'd0, mul_a} << i;
                end
                else begin
                    partial_product[i] <= 8'd0;
                end
            end
        end
    endgenerate

    reg [7:0] sum1;
    reg [7:0] sum2;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            sum1 <= 8'd0;
            sum2 <= 8'd0;
        end
        else begin
            sum1 <= partial_product[0] + partial_product[1];
            sum2 <= partial_product[2] + partial_product[3];
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            mul_out <= 8'd0;
        end
        else begin
            mul_out <= sum1 + sum2;
        end
    end

endmodule