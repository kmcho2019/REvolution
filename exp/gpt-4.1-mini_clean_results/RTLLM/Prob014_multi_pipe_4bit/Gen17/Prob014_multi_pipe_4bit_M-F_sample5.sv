module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // ------------------------------------------------------------------------
    // Extend multiplicand by padding MSBs with zeros for shift operations
    // ------------------------------------------------------------------------
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // ------------------------------------------------------------------------
    // Generate partial products using generate block:
    // partial_products[i] = mul_b[i] ? (ext_mul_a << i) : 0
    // ------------------------------------------------------------------------
    wire [2*size-1:0] partial_products [size-1:0];

    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // ------------------------------------------------------------------------
    // Pipeline Stage 1: sum partial products in pairs and register the results
    // ------------------------------------------------------------------------
    reg [2*size-1:0] stage1_sum_low;   // Sum of partial_products[0] and partial_products[1]
    reg [2*size-1:0] stage1_sum_high;  // Sum of partial_products[2] and partial_products[3]

    // ------------------------------------------------------------------------
    // Pipeline Stage 2: sum the two stage1 sums and register the final product
    // ------------------------------------------------------------------------
    reg [2*size-1:0] stage2_sum;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_sum_low  <= {2*size{1'b0}};
            stage1_sum_high <= {2*size{1'b0}};
            stage2_sum      <= {2*size{1'b0}};
            mul_out         <= {2*size{1'b0}};
        end else begin
            // Register sums of pairs of partial products
            stage1_sum_low  <= partial_products[0] + partial_products[1];
            stage1_sum_high <= partial_products[2] + partial_products[3];

            // Register final sum of stage1 sums
            stage2_sum      <= stage1_sum_low + stage1_sum_high;

            // Output registered final product
            mul_out         <= stage2_sum;
        end
    end

endmodule