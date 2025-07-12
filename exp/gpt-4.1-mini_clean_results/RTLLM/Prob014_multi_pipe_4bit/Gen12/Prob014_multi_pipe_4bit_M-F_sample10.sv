module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by 'size' zeros at MSB side
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // --- Generate partial products combinationally ---
    wire [2*size-1:0] partial_products [0:size-1];
    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_partial_products
            // If mul_b[i] == 1, shift extended multiplicand by i bits; else zero
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // --- Stage 1 registers for partial products: use an array for scalability ---
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

    // --- Balanced adder tree for partial sums ---
    // Level 1 sums: sum partial product pairs
    wire [2*size-1:0] sum_level1_0 = stage1_partial_products[0] + stage1_partial_products[1];
    wire [2*size-1:0] sum_level1_1 = stage1_partial_products[2] + stage1_partial_products[3];

    // Level 2 sum: final sum
    wire [2*size-1:0] sum_level2 = sum_level1_0 + sum_level1_1;

    // --- Stage 2 register: final product ---
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= {2*size{1'b0}};
        else
            mul_out <= sum_level2;
    end

endmodule