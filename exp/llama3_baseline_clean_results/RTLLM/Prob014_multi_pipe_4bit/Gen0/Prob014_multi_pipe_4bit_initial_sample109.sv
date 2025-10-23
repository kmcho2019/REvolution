module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

    parameter size = 4;

    reg [7:0] reg1, reg2;

    // Extend input signals by adding "size" number of zero bits at the most significant bit positions
    wire [7:0] ext_mul_a = {4'd0, mul_a};
    wire [7:0] ext_mul_b = {4'd0, mul_b};

    // Generate partial products for each bit position of the multiplier
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin
            wire [7:0] partial_product;
            assign partial_product = (ext_mul_b[i] == 1'b1) ? (ext_mul_a << i) : 8'd0;
            if (i == 0) begin
                assign reg1 = partial_product;
            end else if (i == 1) begin
                always @(posedge clk or negedge rst_n) begin
                    if (~rst_n) begin
                        reg1 <= 8'd0;
                    end else begin
                        reg1 <= reg1 + partial_product;
                    end
                end
            end else if (i == 2) begin
                always @(posedge clk or negedge rst_n) begin
                    if (~rst_n) begin
                        reg2 <= 8'd0;
                    end else begin
                        reg2 <= reg1 + partial_product;
                    end
                end
            end else if (i == 3) begin
                always @(posedge clk or negedge rst_n) begin
                    if (~rst_n) begin
                        mul_out <= 8'd0;
                    end else begin
                        mul_out <= reg2 + partial_product;
                    end
                end
            end
        end
    endgenerate

endmodule