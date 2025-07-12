module multi_pipe_4bit #(
    parameter size = 4
)(
    input                       clk,
    input                       rst_n,
    input       [size-1:0]      mul_a,
    input       [size-1:0]      mul_b,
    output reg  [(2*size)-1:0]  mul_out
);

    // Extend multiplicand by 'size' zeros at MSB side (high bits)
    wire [(2*size)-1:0] ext_mul_a = { {size{1'b0}}, mul_a };

    // Generate partial products: for each bit in mul_b,
    // shift ext_mul_a by i if mul_b[i] == 1 else zero vector
    wire [(2*size)-1:0] partial_products [0:size-1];

    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : GEN_PARTIAL_PRODUCTS
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {(2*size){1'b0}};
        end
    endgenerate

    // ======================
    // Stage 1: Sum partial products pairwise to reduce summation complexity
    // We pair partial_products[2*i] and partial_products[2*i+1] (if exists)
    // The output is stage1_sums, with half (rounded up) entries
    // ======================
    localparam stage1_len = (size + 1) / 2; // half ceiling

    wire [(2*size)-1:0] stage1_sums [0:stage1_len-1];

    generate
        for (i=0; i<stage1_len; i=i+1) begin : GEN_STAGE1_SUMS
            if (2*i+1 < size) begin
                assign stage1_sums[i] = partial_products[2*i] + partial_products[2*i+1];
            end else begin
                assign stage1_sums[i] = partial_products[2*i];
            end
        end
    endgenerate

    // Stage 1 pipeline register: stores sums of partial product pairs
    reg [(2*size)-1:0] stage1_regs [0:stage1_len-1];

    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j=0; j<stage1_len; j=j+1)
                stage1_regs[j] <= {(2*size){1'b0}};
        end else begin
            for (j=0; j<stage1_len; j=j+1)
                stage1_regs[j] <= stage1_sums[j];
        end
    end

    // ======================
    // Stage 2: Sum all stage1_regs to get final product
    // The width remains 2*size bits, sum over stage1_len values
    // Since stage1_len <= size/2+1, max 2 or 3 terms here for size=4,
    // sum with a generate loop and a for reduction
    // ======================

    reg [(2*size)-1:0] stage2_sum;

    integer k;
    always @* begin
        stage2_sum = {(2*size){1'b0}};
        for (k=0; k<stage1_len; k=k+1) begin
            stage2_sum = stage2_sum + stage1_regs[k];
        end
    end

    // Stage 2 pipeline register: final product output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= {(2*size){1'b0}};
        else
            mul_out <= stage2_sum;
    end

endmodule