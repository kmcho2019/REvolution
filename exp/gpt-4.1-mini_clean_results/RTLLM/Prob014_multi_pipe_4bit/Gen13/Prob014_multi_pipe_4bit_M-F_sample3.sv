module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by 'size' zeros at MSB side to form 2*size bit width
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // --- Generate partial products combinationally ---
    // Each partial product is ext_mul_a shifted left by i bits if mul_b[i] == 1, else zero
    wire [2*size-1:0] partial_products [0:size-1];
    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // --- Stage 1 pipeline registers to store partial products ---
    reg [2*size-1:0] stage1_partial_products [0:size-1];
    generate
        for (i=0; i<size; i=i+1) begin : gen_stage1_regs
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n)
                    stage1_partial_products[i] <= {2*size{1'b0}};
                else
                    stage1_partial_products[i] <= partial_products[i];
            end
        end
    endgenerate

    // --- Balanced adder tree summing the four partial products ---
    // For size=4, sum in two stages:
    // Level 1 sums: pairwise add partial products
    wire [2*size-1:0] sum_level1_0 = stage1_partial_products[0] + stage1_partial_products[1];
    wire [2*size-1:0] sum_level1_1 = stage1_partial_products[2] + stage1_partial_products[3];

    // Level 2 sum: final addition to obtain the product sum
    wire [2*size-1:0] sum_level2 = sum_level1_0 + sum_level1_1;

    // --- Stage 2 pipeline register to store the final product ---
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= {2*size{1'b0}};
        else
            mul_out <= sum_level2;
    end

endmodule