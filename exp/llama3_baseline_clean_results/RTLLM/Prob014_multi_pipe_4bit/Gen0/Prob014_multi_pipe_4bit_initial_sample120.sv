module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output [7:0] mul_out
);

    parameter size = 4;

    reg [7:0] partial_product;
    reg [7:0] sum_register1;
    reg [7:0] sum_register2;
    reg [7:0] final_product;

    assign mul_out = final_product;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            sum_register1 <= 8'd0;
            sum_register2 <= 8'd0;
            final_product <= 8'd0;
        end else begin
            sum_register1 <= partial_product;
            sum_register2 <= sum_register1;
            final_product <= sum_register2;
        end
    end

    integer i;
    always @(*) begin
        partial_product = 8'd0;
        for (i = 0; i < size; i = i + 1) begin
            if (mul_b[i] == 1'b1) begin
                partial_product = partial_product + (mul_a << i);
            end
        end
    end

endmodule