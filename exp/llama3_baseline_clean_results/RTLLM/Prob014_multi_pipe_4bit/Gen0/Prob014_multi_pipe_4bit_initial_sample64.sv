module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output [7:0] mul_out
);

    reg [7:0] reg1;
    reg [7:0] reg2;

    wire [7:0] partial_product [3:0];

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            reg1 <= 8'd0;
            reg2 <= 8'd0;
        end else begin
            if (reg1 == 8'd0) begin
                for (i = 0; i < 4; i++) begin
                    if (mul_b[i] == 1) begin
                        partial_product[i] = mul_a << i;
                    end else begin
                        partial_product[i] = 8'd0;
                    end
                end
                reg1 <= partial_product[0] + partial_product[1] + partial_product[2] + partial_product[3];
            end else begin
                reg2 <= reg1;
            end
        end
    end

    assign mul_out = reg2;

endmodule