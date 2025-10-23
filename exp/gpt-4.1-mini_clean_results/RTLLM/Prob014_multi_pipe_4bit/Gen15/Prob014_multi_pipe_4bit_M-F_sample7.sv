module multi_pipe_4bit (
    input                   clk,
    input                   rst_n,
    input       [3:0]       mul_a,
    input       [3:0]       mul_b,
    output reg  [7:0]       mul_out
);

    // Extend multiplicand by 4 zeros at MSB side: 8-bit wide
    wire [7:0] ext_mul_a = {4'b0000, mul_a};

    // Generate partial products for each bit of mul_b
    wire [7:0] partial_products [3:0];

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_pp
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : 8'b0;
        end
    endgenerate

    // Sum all partial products combinationally
    wire [7:0] sum_all = partial_products[0] 
                       + partial_products[1] 
                       + partial_products[2] 
                       + partial_products[3];

    // Stage 1 register: latch sum of partial products
    reg [7:0] stage1_sum;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            stage1_sum <= 8'b0;
        else
            stage1_sum <= sum_all;
    end

    // Stage 2 register: latch final product output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= 8'b0;
        else
            mul_out <= stage1_sum;
    end

endmodule