module multi_pipe_4bit (
    input                   clk,
    input                   rst_n,
    input       [3:0]       mul_a,
    input       [3:0]       mul_b,
    output reg  [7:0]       mul_out
);

    // Fixed size = 4
    localparam size = 4;

    // Extend multiplicand by 'size' zeros at MSB side
    wire [7:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Generate partial products combinationally for each bit of mul_b
    wire [7:0] partial_product_0 = mul_b[0] ? (ext_mul_a << 0) : 8'd0;
    wire [7:0] partial_product_1 = mul_b[1] ? (ext_mul_a << 1) : 8'd0;
    wire [7:0] partial_product_2 = mul_b[2] ? (ext_mul_a << 2) : 8'd0;
    wire [7:0] partial_product_3 = mul_b[3] ? (ext_mul_a << 3) : 8'd0;

    // Stage 1 registers for each partial product
    reg [7:0] partial_product_reg_0;
    reg [7:0] partial_product_reg_1;
    reg [7:0] partial_product_reg_2;
    reg [7:0] partial_product_reg_3;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            partial_product_reg_0 <= 8'd0;
            partial_product_reg_1 <= 8'd0;
            partial_product_reg_2 <= 8'd0;
            partial_product_reg_3 <= 8'd0;
        end else begin
            partial_product_reg_0 <= partial_product_0;
            partial_product_reg_1 <= partial_product_1;
            partial_product_reg_2 <= partial_product_2;
            partial_product_reg_3 <= partial_product_3;
        end
    end

    // Stage 2: sum of registered partial products combinationally
    wire [7:0] sum_stage2;
    assign sum_stage2 = partial_product_reg_0 + partial_product_reg_1 + partial_product_reg_2 + partial_product_reg_3;

    // Stage 2 register for final product output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= 8'd0;
        else
            mul_out <= sum_stage2;
    end

endmodule