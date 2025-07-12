module multi_pipe_4bit #(
    parameter size = 4
)(
    input                   clk,
    input                   rst_n,
    input       [size-1:0]  mul_a,
    input       [size-1:0]  mul_b,
    output reg  [(2*size)-1:0] mul_out
);

    // Extend multiplicand by 'size' zeros at MSB side to 2*size bits
    wire [(2*size)-1:0] ext_mul_a = { {size{1'b0}}, mul_a };

    // Generate partial products: for each bit in mul_b,
    // shift ext_mul_a by bit index i if mul_b[i] == 1, else zero.
    wire [(2*size)-1:0] partial_products [0:size-1];

    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_pp
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {(2*size){1'b0}};
        end
    endgenerate

    // Sum partial products combinationally
    wire [(2*size)-1:0] sum_all;
    assign sum_all = partial_products[0]
                   + (size > 1 ? partial_products[1] : 0)
                   + (size > 2 ? partial_products[2] : 0)
                   + (size > 3 ? partial_products[3] : 0)
                   + (size > 4 ? partial_products[4] : 0)
                   + (size > 5 ? partial_products[5] : 0)
                   + (size > 6 ? partial_products[6] : 0)
                   + (size > 7 ? partial_products[7] : 0);
    // Note: If size>8, unroll more or use a reduction adder tree as needed.

    // Stage 1 pipeline register: stores sum of partial products
    reg [(2*size)-1:0] stage1_sum;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            stage1_sum <= {(2*size){1'b0}};
        else
            stage1_sum <= sum_all;
    end

    // Stage 2 pipeline register: stores final product output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= {(2*size){1'b0}};
        else
            mul_out <= stage1_sum;
    end

endmodule