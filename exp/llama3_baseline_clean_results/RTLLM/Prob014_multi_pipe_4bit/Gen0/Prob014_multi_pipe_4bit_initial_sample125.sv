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
            mul_out <= 8'd0;
        end
        else begin
            reg1 <= {4'd0, mul_a};
            for (int i = 0; i < 4; i++) begin
                if (mul_b[i])
                    reg2 <= reg2 + ({4'd0, mul_a} << i);
                else
                    reg2 <= reg2;
            end
            mul_out <= reg2;
        end
    end

    // Alternatively, you can use a generate block to simplify the code
    // reg [7:0] partial_product [3:0];
    // always @(posedge clk or negedge rst_n) begin
    //     if (~rst_n) begin
    //         for (int i = 0; i < 4; i++) begin
    //             partial_product[i] <= 8'd0;
    //         end
    //         mul_out <= 8'd0;
    //     end
    //     else begin
    //         for (int i = 0; i < 4; i++) begin
    //             if (mul_b[i])
    //                 partial_product[i] <= {4'd0, mul_a} << i;
    //             else
    //                 partial_product[i] <= 8'd0;
    //         end
    //         mul_out <= partial_product[0] + partial_product[1] + partial_product[2] + partial_product[3];
    //     end
    // end

endmodule