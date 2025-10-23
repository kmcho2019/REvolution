module multi_pipe_4bit #(
    parameter size = 4
)(
    input                   clk,
    input                   rst_n,
    input  [size-1:0]       mul_a,
    input  [size-1:0]       mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by 'size' zeros at MSB side
    wire [2*size-1:0] ext_mul_a = { {size{1'b0}}, mul_a };

    // Generate partial products (size of array = size)
    wire [2*size-1:0] partial_products [0:size-1];
    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Calculate number of partial products: size

    // To build an adder tree we iteratively sum pairs of partial products until only one remains
    // We'll create multiple stages of sums in combinational logic.
    // Store intermediate sums in wires arrays: max levels = ceil(log2(size))
    // For simplicity, preallocate arrays to hold sums at each level.

    localparam integer max_levels = (size <= 1) ? 1 : 
                                    (size <= 2) ? 2 :
                                    (size <= 4) ? 3 :
                                    4; 
    // max_levels covers up to size=8 (can be increased if needed)

    // Declare arrays to hold sums at each level
    // Level 0 is partial_products
    // level_sums[level][index]

    // Using a 2D reg/wire array requires SystemVerilog or Verilog-2001 support
    // Use generate and indexing with arrays of wires

    // Stage 0 sums = partial_products
    // Next stage sums are sums of pairs of previous stage sums
    // If number of elements at a level is odd, the last element is passed through unchanged.

    // To handle arbitrary sizes up to 8 bits (can be modified),
    // we implement adder tree with generate blocks.

    // First, declare an array to hold intermediate sums of size up to 'size' at each level
    // Use a 2D array of wires for combinational sums at each level.
    // Because Verilog-2001 supports arrays of wires, we define an array for each level.

    // For clarity, max input size is 8; for 4 it is enough.

    // Number of elements at each level (level 0 = size)
    function integer level_size;
        input integer lvl;
        input integer sz;
        integer s;
        begin
            s = sz;
            while(lvl > 0) begin
                s = (s + 1) / 2; // ceiling divide by 2
                lvl = lvl - 1;
            end
            level_size = s;
        end
    endfunction

    // Declare arrays for levels: wires only (combinational)
    // Level 0 is partial_products
    // Max levels needed is ceil(log2(size))

    // Generate combinational adder tree
    // We'll define arrays of wires for sums at each level

    // Declare wires arrays
    // For Verilog, declare arrays of vectors (packed arrays of wires)
    // Use generate to build adder stages

    // Declare an array of wires for each level, sized by level_size(level,size)
    // Use a 2D wire array: level_sums[level][index]

    // Use a packed array of vectors: reg/wire [width-1:0] array_name [index]

    // For maximum level, dimension arrays:
    // At level 0: partial_products[size]
    // At level 1: level_size(1,size)
    // At level 2: level_size(2,size)
    // ...
    
    // Maximum levels needed to reduce to 1 sum:
    function integer clog2;
        input integer value;
        integer v;
        begin
            v = 0;
            while (2**v < value) v = v+1;
            clog2 = v;
        end
    endfunction

    localparam int NUM_LEVELS = (size <= 1) ? 1 : clog2(size);

    // Declare wire arrays for sums at each level
    // Each element is [2*size-1:0]
    wire [2*size-1:0] sums[0:NUM_LEVELS][0:size-1]; // oversize for maximum elements, unused entries tied to zero

    integer j;

    // Level 0 sums = partial_products
    generate
        for (j=0; j<size; j=j+1) begin : assign_level0
            assign sums[0][j] = partial_products[j];
        end
        for (j=size; j<size; j=j+1) begin : zero_unused_level0
            assign sums[0][j] = {2*size{1'b0}};
        end
    endgenerate

    // Generate adder tree for levels 1 to NUM_LEVELS
    genvar lvl, idx;
    generate
        for (lvl = 1; lvl <= NUM_LEVELS; lvl = lvl + 1) begin : gen_levels
            localparam prev_level_size = level_size(lvl-1, size);
            localparam curr_level_size = level_size(lvl, size);

            for (idx = 0; idx < curr_level_size; idx = idx + 1) begin : gen_level_adder
                // index of pairs at previous level: 2*idx and 2*idx+1
                if ((2*idx+1) < prev_level_size) begin
                    // Sum pair of previous level sums
                    assign sums[lvl][idx] = sums[lvl-1][2*idx] + sums[lvl-1][2*idx + 1];
                end else if ((2*idx) < prev_level_size) begin
                    // Odd count: propagate the last element without addition
                    assign sums[lvl][idx] = sums[lvl-1][2*idx];
                end else begin
                    // Out of bound index, assign zero
                    assign sums[lvl][idx] = {2*size{1'b0}};
                end
            end
        end
    endgenerate

    // Stage 1 pipeline registers: capture the sum from the last level of combinational adder tree
    reg [2*size-1:0] stage1_sum_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_sum_reg <= {2*size{1'b0}};
        end else begin
            // sums[NUM_LEVELS][0] is the final combinational sum of partial products
            stage1_sum_reg <= sums[NUM_LEVELS][0];
        end
    end

    // Stage 2 pipeline registers: output register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {2*size{1'b0}};
        end else begin
            mul_out <= stage1_sum_reg;
        end
    end

endmodule