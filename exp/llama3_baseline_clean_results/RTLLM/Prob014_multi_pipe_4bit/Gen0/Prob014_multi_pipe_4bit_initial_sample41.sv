module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

    reg [7:0] temp_reg1;
    reg [7:0] temp_reg2;

    always @ (posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            temp_reg1 <= 8'd0;
            temp_reg2 <= 8'd0;
        end else begin
            temp_reg1 <= mul_a * (mul_b[0] ? 1 : 0);
            temp_reg2 <= temp_reg1 + ({4'd0, mul_a} * (mul_b[1] ? 1 : 0)) + 
                                        ({6'd0, mul_a} * (mul_b[2] ? 1 : 0)) + 
                                        ({8'd0, mul_a} * (mul_b[3] ? 1 : 0));
        end
    end

    always @ (posedge clk) begin
        if (~rst_n) begin
            mul_out <= 8'd0;
        end else begin
            mul_out <= temp_reg2;
        end
    end

endmodule