module multi_pipe_4bit #(parameter size = 4)(
    input                    clk,
    input                    rst_n,
    input      [size-1:0]    mul_a,
    input      [size-1:0]    mul_b,
    output reg [2*size-1:0]  mul_out
);

    // Extend multiplicand by size zeros at MSB side
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Stage 0 registers: Register extended multiplicand and multiplier
    reg [2*size-1:0] stage0_mul_a;
    reg [size-1:0]   stage0_mul_b;

    // Stage 1 pipeline registers: hold partial products per multiplier bit
    reg [2*size-1:0] stage1_partial_products [0:size-1];

    // Stage 2 pipeline registers: hold sum of partial products pairs
    // Since size=4 fixed, sum pairs: (0+1) and (2+3)
    reg [2*size-1:0] stage2_sum0;
    reg [2*size-1:0] stage2_sum1;

    // Combinational partial product generation from stage0 registers
    wire [2*size-1:0] partial_products_comb [0:size-1];
    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_partial_products_comb
            assign partial_products_comb[i] = stage0_mul_b[i] ? (stage0_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Combinational sums of partial products pairs
    wire [2*size-1:0] sum0_comb = stage1_partial_products[0] + stage1_partial_products[1];
    wire [2*size-1:0] sum1_comb = stage1_partial_products[2] + stage1_partial_products[3];

    // Pipeline registers update
    integer idx;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage0_mul_a <= 0;
            stage0_mul_b <= 0;
            for (idx=0; idx<size; idx=idx+1)
                stage1_partial_products[idx] <= 0;
            stage2_sum0 <= 0;
            stage2_sum1 <= 0;
            mul_out <= 0;
        end else begin
            // Stage 0 registers
            stage0_mul_a <= ext_mul_a;
            stage0_mul_b <= mul_b;

            // Stage 1 registers: store partial products from stage 0 inputs
            for (idx=0; idx<size; idx=idx+1)
                stage1_partial_products[idx] <= partial_products_comb[idx];

            // Stage 2 registers: sum pairs of partial products from stage 1 registers
            stage2_sum0 <= sum0_comb;
            stage2_sum1 <= sum1_comb;

            // Final output registered as sum of stage2 sums
            mul_out <= stage2_sum0 + stage2_sum1;
        end
    end

endmodule