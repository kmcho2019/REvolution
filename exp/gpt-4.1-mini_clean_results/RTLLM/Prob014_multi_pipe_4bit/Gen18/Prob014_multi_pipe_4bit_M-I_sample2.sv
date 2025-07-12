module multi_pipe_4bit #(
    parameter size = 4
)(
    input                      clk,
    input                      rst_n,
    input      [size-1:0]      mul_a,
    input      [size-1:0]      mul_b,
    output reg [(2*size)-1:0]  mul_out
);

    // Extend multiplicand by 'size' zero bits at MSB side to 2*size bits width
    wire [(2*size)-1:0] ext_mul_a = { {size{1'b0}}, mul_a };

    // Generate partial products: each partial product shifted left by bit index if multiplier bit set, else zero
    wire [(2*size)-1:0] partial_products [0:size-1];

    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : GEN_PARTIAL_PRODUCTS
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {(2*size){1'b0}};
        end
    endgenerate

    // ------------------------------
    // Stage 1 pipeline registers:
    // Pairwise sum of partial products:
    // For size=4: 
    //  stage1_regs[0] = pp0 + pp1
    //  stage1_regs[1] = pp2 + pp3
    // ------------------------------

    localparam stage1_num = (size + 1) / 2; // ceiling division

    wire [(2*size)-1:0] stage1_sums [0:stage1_num-1];

    generate
        for (i = 0; i < stage1_num; i = i + 1) begin : GEN_STAGE1_SUMS
            if (2*i + 1 < size) begin
                assign stage1_sums[i] = partial_products[2*i] + partial_products[2*i + 1];
            end else begin
                assign stage1_sums[i] = partial_products[2*i]; // for odd size, last partial product alone
            end
        end
    endgenerate

    reg [(2*size)-1:0] stage1_regs [0:stage1_num-1];

    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j = 0; j < stage1_num; j = j + 1)
                stage1_regs[j] <= {(2*size){1'b0}};
        end else begin
            for (j = 0; j < stage1_num; j = j + 1)
                stage1_regs[j] <= stage1_sums[j];
        end
    end

    // ------------------------------
    // Stage 2 pipeline registers:
    // Final summation of stage1_regs
    // Balanced adder tree in combinational logic (for size=4, just one addition)
    // Store result in output register mul_out
    // ------------------------------

    wire [(2*size)-1:0] stage2_sum;

    // Balanced sum of stage1_regs:
    // For size=4, stage1_num=2 => stage2_sum = stage1_regs[0] + stage1_regs[1]
    // If size odd and stage1_num=1, then stage2_sum = stage1_regs[0]
    generate
        if (stage1_num == 1) begin : GEN_STAGE2_SUM_1
            assign stage2_sum = stage1_regs[0];
        end else begin : GEN_STAGE2_SUM_2
            assign stage2_sum = stage1_regs[0] + stage1_regs[1];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= {(2*size){1'b0}};
        else
            mul_out <= stage2_sum;
    end

endmodule