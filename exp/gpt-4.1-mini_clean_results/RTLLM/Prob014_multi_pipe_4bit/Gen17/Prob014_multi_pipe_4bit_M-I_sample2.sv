module multi_pipe_4bit #(
    parameter size = 4
)(
    input                      clk,
    input                      rst_n,
    input       [size-1:0]     mul_a,
    input       [size-1:0]     mul_b,
    output reg  [(2*size)-1:0] mul_out
);

    // Extend multiplicand by 'size' zeros at MSB side: width 2*size
    wire [(2*size)-1:0] ext_mul_a = { {size{1'b0}}, mul_a };

    // Generate partial products: for each bit in mul_b,
    // shift ext_mul_a by i if mul_b[i] == 1, else zero.
    wire [(2*size)-1:0] partial_products [0:size-1];

    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_pp
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : { (2*size){1'b0} };
        end
    endgenerate

    // Since size=4, split partial products into two groups for stage 1 sums
    // Group 1 sum: partial_products[0] + partial_products[1]
    wire [(2*size)-1:0] sum_g1 = partial_products[0] + partial_products[1];
    // Group 2 sum: partial_products[2] + partial_products[3]
    wire [(2*size)-1:0] sum_g2 = partial_products[2] + partial_products[3];

    // Stage 1 pipeline registers to store group sums
    reg [(2*size)-1:0] stage1_g1, stage1_g2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_g1 <= {(2*size){1'b0}};
            stage1_g2 <= {(2*size){1'b0}};
        end else begin
            stage1_g1 <= sum_g1;
            stage1_g2 <= sum_g2;
        end
    end

    // Stage 2 pipeline register: sum the two registered partial sums and register final product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= {(2*size){1'b0}};
        else
            mul_out <= stage1_g1 + stage1_g2;
    end

endmodule