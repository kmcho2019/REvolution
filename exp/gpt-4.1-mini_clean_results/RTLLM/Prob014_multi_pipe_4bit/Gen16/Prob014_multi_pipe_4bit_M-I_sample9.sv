module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by padding MSBs with zeros
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Generate partial products
    // partial_products[i] = mul_b[i] ? (ext_mul_a << i) : 0
    wire [2*size-1:0] partial_products [size-1:0];

    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_pp
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Stage 1 registers: sum partial products in pairs to reduce combinational delay
    reg [2*size-1:0] stage1_sum_low;  // sum of partial_products[0] and partial_products[1]
    reg [2*size-1:0] stage1_sum_high; // sum of partial_products[2] and partial_products[3]

    // Stage 2 register: final product sum
    reg [2*size-1:0] stage2_sum;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_sum_low  <= {2*size{1'b0}};
            stage1_sum_high <= {2*size{1'b0}};
            stage2_sum      <= {2*size{1'b0}};
            mul_out         <= {2*size{1'b0}};
        end else begin
            // Stage 1 sums registered
            stage1_sum_low  <= partial_products[0] + partial_products[1];
            stage1_sum_high <= partial_products[2] + partial_products[3];

            // Stage 2 sum registered
            stage2_sum      <= stage1_sum_low + stage1_sum_high;

            // Output registered
            mul_out         <= stage2_sum;
        end
    end

endmodule