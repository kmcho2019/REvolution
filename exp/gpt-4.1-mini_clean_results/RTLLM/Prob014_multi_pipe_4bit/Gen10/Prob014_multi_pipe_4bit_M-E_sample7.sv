module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);
    // Extend multiplicand by 'size' zero bits at MSB
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // --- Generate partial products combinationally ---
    // Each partial product is 2*size bits: (mul_b[i] ? ext_mul_a << i : 0)
    wire [2*size-1:0] partial_products [size-1:0];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // --- Pack partial products into a single vector to register ---
    localparam int PARTIAL_BITS = 2*size;
    localparam int CONCAT_WIDTH = size * PARTIAL_BITS;

    wire [CONCAT_WIDTH-1:0] partials_concat_comb;
    genvar j;
    generate
        for (j = 0; j < size; j = j + 1) begin : pack_partials
            assign partials_concat_comb[(j+1)*PARTIAL_BITS-1 -: PARTIAL_BITS] = partial_products[j];
        end
    endgenerate

    // Stage 1 register: register packed partial products
    reg [CONCAT_WIDTH-1:0] stage1_partials;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_partials <= {CONCAT_WIDTH{1'b0}};
        end else begin
            stage1_partials <= partials_concat_comb;
        end
    end

    // --- Balanced adder tree to sum partial products at stage 2 ---
    // Extract partial products from stage1_partials and sum via balanced tree combinationally.

    // Function to sum an array of values (implemented as recursion via function)
    function automatic [PARTIAL_BITS-1:0] adder_tree_sum;
        input integer length;
        input [CONCAT_WIDTH-1:0] data_vector;
        integer idx;
        reg [PARTIAL_BITS-1:0] sums[0:((1<<size)-1)]; // size is max 4, so array size limited
        reg [PARTIAL_BITS-1:0] left_sum;
        reg [PARTIAL_BITS-1:0] right_sum;
    begin
        if (length == 1) begin
            // Return single partial product extracted from data_vector
            adder_tree_sum = data_vector[(PARTIAL_BITS)-1 -: PARTIAL_BITS];
        end else begin
            // Split data_vector into two halves and sum recursively
            integer mid;
            mid = length >> 1;
            left_sum  = adder_tree_sum(mid, data_vector[(length*PARTIAL_BITS)-1 -: mid*PARTIAL_BITS]);
            right_sum = adder_tree_sum(length - mid, data_vector[(length*PARTIAL_BITS - mid*PARTIAL_BITS)-1 -: (length - mid)*PARTIAL_BITS]);
            adder_tree_sum = left_sum + right_sum;
        end
    end
    endfunction

    wire [PARTIAL_BITS-1:0] sum_stage2_comb;
    assign sum_stage2_comb = adder_tree_sum(size, stage1_partials);

    // Stage 2 register: register final output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {PARTIAL_BITS{1'b0}};
        end else begin
            mul_out <= sum_stage2_comb;
        end
    end

endmodule