module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output [7:0] mul_out
);

    reg [7:0] sum1, sum2;
    reg [7:0] mul_out_reg;
    wire [7:0] partial_product [3:0];

    // Generate partial products
    genvar i;
    generate
        for(i = 0; i < 4; i = i + 1) begin
            assign partial_product[i] = (mul_b[i] == 1'b1) ? (mul_a << i) : 8'd0;
        end
    endgenerate

    // Store intermediate sum values
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            sum1 <= 8'd0;
            sum2 <= 8'd0;
        end
        else begin
            sum1 <= (partial_product[0] + partial_product[1]);
            sum2 <= (partial_product[2] + partial_product[3]);
        end
    end

    // Calculate final product
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            mul_out_reg <= 8'd0;
        end
        else begin
            mul_out_reg <= sum1 + sum2;
        end
    end

    assign mul_out = mul_out_reg;

endmodule