module multi_pipe_4bit #(
    parameter size = 4,
    parameter product_width = 2 * size
)(
    input                       clk,
    input                       rst_n,      // active low async reset
    input       [size-1:0]      mul_a,
    input       [size-1:0]      mul_b,
    output reg  [product_width-1:0] mul_out
);

    // Zero-extend multiplicand (mul_a) by size bits on MSB side
    wire [product_width-1:0] mul_a_ext = {{size{1'b0}}, mul_a};

    // --------------------
    // Stage 1: Generate partial products combinationally
    // For each bit i of mul_b:
    //   If mul_b[i] == 1: partial product = mul_a_ext << i
    //   Else: zero
    wire [product_width-1:0] partial_products [size-1:0];
    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (mul_a_ext << i) : {product_width{1'b0}};
        end
    endgenerate

    // Register array for partial products (pipeline stage 1)
    reg [product_width-1:0] pp_reg [size-1:0];
    integer idx;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (idx=0; idx<size; idx=idx+1)
                pp_reg[idx] <= {product_width{1'b0}};
        end else begin
            for (idx=0; idx<size; idx=idx+1)
                pp_reg[idx] <= partial_products[idx];
        end
    end

    // --------------------
    // Stage 2: Sum registered partial products
    // To keep pipeline balanced, use a balanced adder tree with registers at this stage

    // First sum stage: pairwise add partial products
    // Number of pairs = size/2 (integer division)
    localparam half_size = (size + 1) >> 1; // ceil(size/2)
    wire [product_width-1:0] sum_pairs [half_size-1:0];

    generate
        for (i=0; i<(size>>1); i=i+1) begin : gen_sum_pairs
            assign sum_pairs[i] = pp_reg[2*i] + pp_reg[2*i+1];
        end
        // If size is odd, carry last element to next stage directly
        if (size % 2 == 1) begin : gen_sum_pairs_odd
            assign sum_pairs[half_size-1] = pp_reg[size-1];
        end
    endgenerate

    // Register for sum pairs (stage 2 registers)
    reg [product_width-1:0] sum_pairs_reg [half_size-1:0];
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (idx=0; idx<half_size; idx=idx+1)
                sum_pairs_reg[idx] <= {product_width{1'b0}};
        end else begin
            for (idx=0; idx<half_size; idx=idx+1)
                sum_pairs_reg[idx] <= sum_pairs[idx];
        end
    end

    // Final summation stage: sum all sum_pairs_reg elements (this is combinational)
    // Because size=4 fixed, this is either:
    // sum_pairs_reg[0] + sum_pairs_reg[1] for size=4
    // sum_pairs_reg[0] for size=1
    // sum_pairs_reg[0] + sum_pairs_reg[1] for size=3
    // Handle generically for any size <=4 (per requirement size=4)

    wire [product_width-1:0] sum_final;
    generate
        if (size == 1) begin
            assign sum_final = sum_pairs_reg[0];
        end else if (size == 2) begin
            assign sum_final = sum_pairs_reg[0];
        end else if (size == 3) begin
            assign sum_final = sum_pairs_reg[0] + sum_pairs_reg[1];
        end else if (size == 4) begin
            assign sum_final = sum_pairs_reg[0] + sum_pairs_reg[1];
        end else begin
            assign sum_final = {product_width{1'b0}}; // default zero for unsupported size
        end
    endgenerate

    // --------------------
    // Stage 3: Register final product output (second pipeline register stage)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= {product_width{1'b0}};
        else
            mul_out <= sum_final;
    end

endmodule