module multi_pipe_4bit #(parameter size = 4)(
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by size zeros at MSB side
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // ==========================
    // Pipeline stage 0 registers: Register inputs
    // ==========================
    reg [2*size-1:0] stage0_mul_a;
    reg [size-1:0]   stage0_mul_b;

    // ==========================
    // Pipeline stage 1: Generate partial products from stage0 inputs and register them
    // Partial products array: one for each multiplier bit
    // ==========================
    reg [2*size-1:0] stage1_partial_products [0:size-1];

    genvar i;
    wire [2*size-1:0] partial_products_comb [0:size-1];
    generate
        for (i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products_comb[i] = stage0_mul_b[i] ? (stage0_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // ==========================
    // Pipeline stage 2: Sum partial products pairwise and register sums
    // Partial products: 4 -> sum pairs: (0+1), (2+3)
    // ==========================
    reg [2*size-1:0] stage2_sum0;
    reg [2*size-1:0] stage2_sum1;

    // ==========================
    // Pipeline stage 3: Final sum and output register
    // ==========================
    reg [2*size-1:0] stage3_final_sum;

    // ==========================
    // Sequential logic for pipeline registers
    // ==========================
    integer idx;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage0_mul_a <= 0;
            stage0_mul_b <= 0;
            for (idx=0; idx<size; idx=idx+1) begin
                stage1_partial_products[idx] <= 0;
            end
            stage2_sum0 <= 0;
            stage2_sum1 <= 0;
            stage3_final_sum <= 0;
            mul_out <= 0;
        end else begin
            // Stage 0: register inputs
            stage0_mul_a <= ext_mul_a;
            stage0_mul_b <= mul_b;

            // Stage 1: register partial products generated from stage0 inputs
            for (idx=0; idx<size; idx=idx+1) begin
                stage1_partial_products[idx] <= partial_products_comb[idx];
            end

            // Stage 2: sum partial products pairs and register results
            // sum (0 + 1)
            stage2_sum0 <= stage1_partial_products[0] + stage1_partial_products[1];
            // sum (2 + 3)
            stage2_sum1 <= stage1_partial_products[2] + stage1_partial_products[3];

            // Stage 3: final sum and output register
            stage3_final_sum <= stage2_sum0 + stage2_sum1;

            // Output register
            mul_out <= stage3_final_sum;
        end
    end

endmodule