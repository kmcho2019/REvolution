module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

    reg [7:0] stage1 [3:0];
    reg [7:0] stage2;

    // Generate partial products and store in stage1
    genvar i;
    generate
        for (i = 0; i < 4; i++) begin
            always @(mul_a, mul_b) begin
                if (mul_b[i] == 1'b1) begin
                    stage1[i] = mul_a << i;
                end else begin
                    stage1[i] = 8'd0;
                end
            end
        end
    endgenerate

    // Add partial products and store in stage2
    always @(posedge clk, negedge rst_n) begin
        if (~rst_n) begin
            stage2 <= 8'd0;
        end else begin
            stage2 <= stage1[0] + stage1[1] + stage1[2] + stage1[3];
        end
    end

    // Calculate final product and output
    always @(posedge clk, negedge rst_n) begin
        if (~rst_n) begin
            mul_out <= 8'd0;
        end else begin
            mul_out <= stage2;
        end
    end

endmodule