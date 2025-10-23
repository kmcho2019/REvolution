module multi_pipe_4bit #(parameter size = 4) (
    input                     clk,
    input                     rst_n,
    input      [size-1:0]     mul_a,
    input      [size-1:0]     mul_b,
    output reg [2*size-1:0]   mul_out
);

    // Extend multiplicand by size zeros at MSB side before stage 1 register
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Stage 1 registers: registered inputs and partial products
    reg [2*size-1:0] stage1_mul_a;
    reg [size-1:0]   stage1_mul_b;
    reg [2*size-1:0] stage1_partial_products [0:size-1];

    // Partial products combinational generation from stage1 inputs
    wire [2*size-1:0] partial_products_comb [0:size-1];
    genvar i;
    generate
        for(i=0; i<size; i=i+1) begin : gen_partial_products_comb
            assign partial_products_comb[i] = stage1_mul_b[i] ? (stage1_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Stage 2 registers: sum of all partial products
    reg [2*size-1:0] stage2_sum;

    // Pipeline process
    always @(posedge clk or negedge rst_n) begin
        integer i; // local loop variable for procedural loop
        if (!rst_n) begin
            stage1_mul_a <= 0;
            stage1_mul_b <= 0;
            for (i=0; i<size; i=i+1)
                stage1_partial_products[i] <= 0;
            stage2_sum <= 0;
            mul_out <= 0;
        end else begin
            // Stage 1: register inputs and partial products
            stage1_mul_a <= ext_mul_a;
            stage1_mul_b <= mul_b;
            for (i=0; i<size; i=i+1)
                stage1_partial_products[i] <= partial_products_comb[i];

            // Stage 2: sum partial products from stage1 registers and register sum
            stage2_sum <= stage1_partial_products[0] + stage1_partial_products[1] +
                          stage1_partial_products[2] + stage1_partial_products[3];

            // Final product output registered from stage2 sum
            mul_out <= stage2_sum;
        end
    end

endmodule