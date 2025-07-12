module multi_pipe_4bit #(
    parameter size = 4
)(
    input                       clk,
    input                       rst_n,
    input       [size-1:0]      mul_a,
    input       [size-1:0]      mul_b,
    output reg  [(2*size)-1:0]  mul_out
);

    // Extend inputs by adding 'size' zeros at MSB side
    wire [(2*size)-1:0] ext_a = { {size{1'b0}}, mul_a };
    wire [(2*size)-1:0] ext_b = { {size{1'b0}}, mul_b };

    // Partial products: each is ext_a shifted by i if mul_b[i] is 1, else zero
    wire [(2*size)-1:0] partial_product [size-1:0];
    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_product[i] = ext_b[i] ? (ext_a << i) : { (2*size){1'b0} };
        end
    endgenerate

    // Pipeline registers for Stage 1: store partial products
    reg [(2*size)-1:0] stage1_pp [size-1:0];

    // Pipeline registers for Stage 2: sum pairs of partial products
    reg [(2*size)-1:0] stage2_sum0;
    reg [(2*size)-1:0] stage2_sum1;

    // Pipeline register for Stage 3: sum of stage2_sum0 + stage2_sum1
    reg [(2*size)-1:0] stage3_sum;

    integer idx;

    // Stage 1: Register partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (idx = 0; idx < size; idx = idx + 1)
                stage1_pp[idx] <= 0;
        end else begin
            for (idx = 0; idx < size; idx = idx + 1)
                stage1_pp[idx] <= partial_product[idx];
        end
    end

    // Stage 2: sum pairs of partial products from Stage 1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_sum0 <= 0;
            stage2_sum1 <= 0;
        end else begin
            stage2_sum0 <= stage1_pp[0] + stage1_pp[1];
            stage2_sum1 <= stage1_pp[2] + stage1_pp[3];
        end
    end

    // Stage 3: sum results from Stage 2 and output the final product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage3_sum <= 0;
            mul_out <= 0;
        end else begin
            stage3_sum <= stage2_sum0 + stage2_sum1;
            mul_out <= stage3_sum;
        end
    end

endmodule