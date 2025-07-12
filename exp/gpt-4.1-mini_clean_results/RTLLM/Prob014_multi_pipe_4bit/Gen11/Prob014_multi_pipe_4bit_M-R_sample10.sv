module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by 'size' zero bits at MSB side
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Generate partial products combinationally
    wire [2*size-1:0] partial_products [0:size-1];
    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_partial
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Stage 1 registers for partial products and inputs (no arrays, use generate)
    // Individual registers for each partial product
    reg [2*size-1:0] stage1_partial_products [0:size-1];
    reg [2*size-1:0] stage1_mul_a;
    reg [size-1:0]   stage1_mul_b;

    // Sequential block to register inputs and partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_mul_a <= 0;
            stage1_mul_b <= 0;
            // Clear each stage1 partial product register
            for (integer idx = 0; idx < size; idx = idx + 1) begin
                stage1_partial_products[idx] <= 0;
            end
        end else begin
            stage1_mul_a <= ext_mul_a;
            stage1_mul_b <= mul_b;
            for (integer idx = 0; idx < size; idx = idx + 1) begin
                stage1_partial_products[idx] <= partial_products[idx];
            end
        end
    end

    // Balanced combinational adder tree for partial products sum (stage 2)
    // We first create wires for intermediate sums to build the tree
    // For size=4: sum pairs 0+1 and 2+3, then sum those results
    // For general size, build a tree of sums iteratively

    // Calculate next level widths
    localparam stage_width = 2*size;

    // Function to compute ceil(log2) for array size in generate loops
    function integer clog2;
        input integer value;
        integer i;
        begin
            clog2 = 0;
            for (i = value - 1; i > 0; i = i >> 1)
                clog2 = clog2 + 1;
        end
    endfunction

    // Number of stages in adder tree:
    localparam tree_levels = clog2(size);

    // Declare arrays of wires for each level of the adder tree
    // level_sums[level][index]
    // Level 0: stage1_partial_products
    // Levels above: sums of pairs

    // For synthesis friendliness, max nodes per level: ceiling(size/(2^level))
    // Use generate loops to build the tree

    // Declare 2D wire array for sums
    // Since Verilog-2001 doesn't allow 2D packed arrays of wires easily,
    // we flatten the indexing for each level as individual wires.

    // We'll implement using a generate block and intermediate variables.
    // To simplify: create arrays of wires for each level.

    // We'll define the number of nodes at each level and store intermediate sums.
    // level_nodes[level] = (size + 2^level - 1) >> level (ceil div by 2^level)
    function integer nodes_at_level;
        input integer level;
        begin
            nodes_at_level = (size + (1 << level) - 1) >> level;
        end
    endfunction

    // Declare wires for each level sums dynamically
    // Max tree_levels is 2 for size=4, so manageable.

    // Level 0 wires (inputs from stage1_partial_products)
    wire [stage_width-1:0] level0_sums [0:size-1];
    generate
        for (i=0; i<size; i=i+1) begin
            assign level0_sums[i] = stage1_partial_products[i];
        end
    endgenerate

    // Level 1 wires
    localparam level1_nodes = nodes_at_level(1);
    wire [stage_width-1:0] level1_sums [0:level1_nodes-1];

    generate
        for (i=0; i<level1_nodes; i=i+1) begin
            // sum pairs of level0_sums: index 2*i and 2*i+1 if exists
            wire [stage_width-1:0] op1 = (2*i < size) ? level0_sums[2*i] : {stage_width{1'b0}};
            wire [stage_width-1:0] op2 = (2*i+1 < size) ? level0_sums[2*i+1] : {stage_width{1'b0}};
            assign level1_sums[i] = op1 + op2;
        end
    endgenerate

    // Level 2 wires if needed (for size=4, only one node)
    localparam level2_nodes = nodes_at_level(2);
    wire [stage_width-1:0] level2_sums [0:level2_nodes-1];

    generate
        for (i=0; i<level2_nodes; i=i+1) begin
            // sum pairs of level1_sums: index 2*i and 2*i+1 if exists
            wire [stage_width-1:0] op1 = (2*i < level1_nodes) ? level1_sums[2*i] : {stage_width{1'b0}};
            wire [stage_width-1:0] op2 = (2*i+1 < level1_nodes) ? level1_sums[2*i+1] : {stage_width{1'b0}};
            assign level2_sums[i] = op1 + op2;
        end
    endgenerate

    // The top sum is at the highest level, level2_sums[0] if tree_levels>=2, else from lower level
    wire [stage_width-1:0] combinational_sum;
    generate
        if (tree_levels == 0) begin
            // size = 1, just single partial product
            assign combinational_sum = level0_sums[0];
        end else if (tree_levels == 1) begin
            assign combinational_sum = level1_sums[0];
        end else begin
            assign combinational_sum = level2_sums[0];
        end
    endgenerate

    // Stage 2 register: latch the final sum into mul_out
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 0;
        end else begin
            mul_out <= combinational_sum;
        end
    end

endmodule