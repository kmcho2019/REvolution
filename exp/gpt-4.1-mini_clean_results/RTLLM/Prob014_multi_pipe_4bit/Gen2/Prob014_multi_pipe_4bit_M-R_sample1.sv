module multi_pipe_4bit #(parameter size=4)(
    input                    clk,
    input                    rst_n,
    input  [size-1:0]        mul_a,
    input  [size-1:0]        mul_b,
    output reg [2*size-1:0]  mul_out
);

// Extend inputs by size zeros at MSB side
wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

// Pipeline stage 0 registers to synchronize inputs
reg [2*size-1:0] stage0_mul_a;
reg [size-1:0]   stage0_mul_b;

// Partial products combinationally generated from stage0 inputs
wire [2*size-1:0] partial_products [0:size-1];
genvar i;
generate
    for (i=0; i<size; i=i+1) begin : GEN_PARTIAL_PRODUCTS
        assign partial_products[i] = stage0_mul_b[i] ? (stage0_mul_a << i) : {2*size{1'b0}};
    end
endgenerate

// Pipeline stage 1 registers: sums of partial products pairs
reg [2*size-1:0] stage1_sum0, stage1_sum1;

// Pipeline stage 2 register: sum of stage 1 sums
reg [2*size-1:0] stage2_sum;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers and output
        stage0_mul_a <= 0;
        stage0_mul_b <= 0;
        stage1_sum0  <= 0;
        stage1_sum1  <= 0;
        stage2_sum   <= 0;
        mul_out      <= 0;
    end else begin
        // Stage 0: register inputs with zero extension
        stage0_mul_a <= ext_mul_a;
        stage0_mul_b <= mul_b;

        // Stage 1: sum pairs of partial products (registered from stage0 inputs)
        stage1_sum0 <= partial_products[0] + partial_products[1];
        stage1_sum1 <= partial_products[2] + partial_products[3];

        // Stage 2: sum of stage1 sums
        stage2_sum <= stage1_sum0 + stage1_sum1;

        // Output register updates with final sum from stage2
        mul_out <= stage2_sum;
    end
end

endmodule