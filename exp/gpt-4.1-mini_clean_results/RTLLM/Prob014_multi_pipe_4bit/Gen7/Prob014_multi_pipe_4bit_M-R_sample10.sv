module multi_pipe_4bit #(
    parameter size = 4
)(
    input                   clk,
    input                   rst_n,
    input  [size-1:0]       mul_a,
    input  [size-1:0]       mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend inputs by zero-padding MSBs (size zeros)
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};
    wire [2*size-1:0] ext_mul_b = {{size{1'b0}}, mul_b}; // extended multiplier (not used in indexing, but per spec)

    // Generate partial products combinationally
    wire [2*size-1:0] partial_products [size-1:0];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Stage 1 registers: sum partial products bits [0:1] and [2:3]
    reg [2*size-1:0] stage1_sum_low;
    reg [2*size-1:0] stage1_sum_high;

    // Stage 2 registers: sum stage1 outputs from previous cycle
    reg [2*size-1:0] stage2_sum;

    always @(posedge clk) begin
        if (!rst_n) begin
            stage1_sum_low  <= {2*size{1'b0}};
            stage1_sum_high <= {2*size{1'b0}};
            stage2_sum      <= {2*size{1'b0}};
            mul_out         <= {2*size{1'b0}};
        end else begin
            // Stage 1: sum partial products bits [0] and [1], bits [2] and [3]
            stage1_sum_low  <= partial_products[0] + partial_products[1];
            stage1_sum_high <= partial_products[2] + partial_products[3];

            // Stage 2: sum stage1 sums from previous cycle
            stage2_sum      <= stage1_sum_low + stage1_sum_high;

            // Output registered final product (result delayed by 2 cycles)
            mul_out         <= stage2_sum;
        end
    end

endmodule