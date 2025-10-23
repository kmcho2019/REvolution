module popcount #(
    parameter WIDTH = 8
)(
    input  [WIDTH-1:0] in,
    output [$clog2(WIDTH+1)-1:0] out
);
    // Recursive popcount implementation via generate
    // Base cases:
    // WIDTH == 1: out = in[0]
    // WIDTH > 1: split input in half and sum popcounts recursively

    generate
        if (WIDTH == 1) begin
            assign out = in[0];
        end else begin
            localparam L = WIDTH / 2;
            localparam R = WIDTH - L;
            wire [$clog2(L+1)-1:0] left_count;
            wire [$clog2(R+1)-1:0] right_count;

            popcount #(.WIDTH(L)) pop_left (.in(in[L-1:0]), .out(left_count));
            popcount #(.WIDTH(R)) pop_right(.in(in[WIDTH-1:L]), .out(right_count));

            assign out = left_count + right_count;
        end
    endgenerate
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0]   out
);
    // Break the input into 32 chunks:
    // 31 chunks of 8 bits, 1 chunk of 7 bits

    // Partial counts array of size 32; each count width = max popcount per chunk (up to 8)
    localparam NUM_CHUNKS = 32;
    localparam CHUNK_WIDTHS [0:NUM_CHUNKS-1] = {
        7, 8, 8, 8, 8, 8, 8, 8, 8, 8,
        8, 8, 8, 8, 8, 8, 8, 8, 8, 8,
        8, 8, 8, 8, 8, 8, 8, 8, 8, 8,
        8, 8
    }; // chunk 0 is 7 bits, rest 8 bits for easier indexing

    wire [3:0] partial_counts [0:NUM_CHUNKS-1]; // max popcount is 8 => 4 bits

    genvar i;
    generate
        for (i = 0; i < NUM_CHUNKS; i = i + 1) begin : gen_popcounts
            localparam int w = (i == 0) ? 7 : 8;
            localparam int start_bit = (i == 0) ? 0 : (7 + (i-1)*8);
            wire [w-1:0] chunk_bits;
            assign chunk_bits = in[start_bit +: w];
            popcount #(.WIDTH(w)) pop_i (
                .in(chunk_bits),
                .out(partial_counts[i])
            );
        end
    endgenerate

    // Function to recursively sum an array of values in a balanced binary tree manner
    // sum_width is max bitwidth of inputs + log2 of number of elements
    function automatic [15:0] clog2;
        input [15:0] val;
        integer j;
        begin
            clog2 = 0;
            for (j=val-1; j>0; j=j>>1)
                clog2 = clog2 + 1;
        end
    endfunction

    // Recursive adder function: takes an array of elements and sums them
    // Implemented as generate block below

    // First, flatten partial_counts into a packed wire array for easier recursion
    // partial_counts have 4 bits each, max sum is 255, so 8 bits output needed
    localparam PARTIAL_WIDTH = 4;
    localparam TOTAL_COUNTS = NUM_CHUNKS;
    localparam SUM_WIDTH = 8; // Since max 255 ones total

    // Create a 2D packed wire for partial counts
    wire [PARTIAL_WIDTH-1:0] partial_flat [0:TOTAL_COUNTS-1];
    generate
        for (i=0; i<TOTAL_COUNTS; i=i+1) begin
            assign partial_flat[i] = partial_counts[i];
        end
    endgenerate

    // Recursive adder tree generate block
    // This module sums an array of inputs into a single output
    // width: bit width of inputs
    // size: number of elements
    // inputs: array of input values

    // Use a generate loop with parameters to create the adder tree
    // Use a generate block with intermediate wires to store sums at each level

    // Compute number of levels needed
    localparam int LEVELS = clog2(TOTAL_COUNTS);

    // Create an array of sums for each level, level 0 is the input partial counts
    // Each level halves the number of elements, rounding up

    // Declare arrays of wires for sums per level
    // To simplify, we use a packed 2D array for each level
    // Max elements at level 0 = TOTAL_COUNTS
    // Each higher level roughly half of previous

    // Generate sums for each level
    // Level 0: partial_flat (4-bit each)
    // Each addition increases bit width by 1
    // To keep widths safe, we allocate sufficient bits to sums on each level

    // Declare arrays of wires dynamically (packed arrays of packed arrays)
    // Use localparam and generate to define these

    // We need to unpack and pack bits carefully: use separate wires for each sum

    // First, define maximum width per level
    // At level 0: width = PARTIAL_WIDTH = 4
    // Each add increases width by 1 (worst case)
    // So level L width = PARTIAL_WIDTH + L

    // Declare wires
    // max elements per level = (TOTAL_COUNTS + 2^L -1) >> L (round up)
    // We'll just declare max size = (TOTAL_COUNTS+1)>>L to cover sizes

    // Using generate with for loops inside generate block

    // Level 0 wires
    wire [PARTIAL_WIDTH-1:0] sums_level_0 [0:TOTAL_COUNTS-1];
    // Assign partial_flat to sums_level_0
    generate
        for (i=0; i<TOTAL_COUNTS; i=i+1) begin
            assign sums_level_0[i] = partial_flat[i];
        end
    endgenerate

    // Define maximum levels and arrays of wires for sums_level_1 ... sums_level_LEVELS
    // We declare arrays for each level, width increases by 1 each level

    // Use a generate block for all levels > 0
    genvar level, j;
    // We'll build a recursive summation tree in a loop
    // sums_level_k array width: PARTIAL_WIDTH + k

    // Create wires for all levels and perform additions
    // Final output after LEVELS reductions will be single sum

    // Declare sums arrays for all levels using generate and localparam
    // Use generate blocks inside generate block due to Verilog syntax

    // Internal module to do the adder tree
    // Instantiate a hierarchical module for clarity

    module sum_tree #(
        parameter integer INPUT_WIDTH = PARTIAL_WIDTH,
        parameter integer NUM_INPUTS = TOTAL_COUNTS
    ) (
        input  wire [INPUT_WIDTH-1:0] data_in [0:NUM_INPUTS-1],
        output wire [INPUT_WIDTH + $clog2(NUM_INPUTS) - 1:0] sum_out
    );
        // Local parameters
        localparam integer LEVELS = (NUM_INPUTS == 1) ? 0 : $clog2(NUM_INPUTS);

        // Handle base case: if NUM_INPUTS == 1, sum_out = data_in[0]
        generate
            if (NUM_INPUTS == 1) begin
                assign sum_out = data_in[0];
            end else begin
                // Number of sums in next level (half rounded up)
                localparam integer NEXT_NUM_INPUTS = (NUM_INPUTS + 1) / 2;
                localparam integer NEXT_WIDTH = INPUT_WIDTH + 1;

                wire [INPUT_WIDTH:0] sum_pairs [0:NEXT_NUM_INPUTS-1];

                // Sum pairs of inputs
                genvar idx;
                for (idx = 0; idx < NEXT_NUM_INPUTS; idx = idx + 1) begin : pair_add
                    wire [INPUT_WIDTH-1:0] a = data_in[2*idx];
                    wire [INPUT_WIDTH-1:0] b = (2*idx+1 < NUM_INPUTS) ? data_in[2*idx+1] : {INPUT_WIDTH{1'b0}};
                    assign sum_pairs[idx] = a + b;
                end

                // Recursively sum the sum_pairs
                sum_tree #(
                    .INPUT_WIDTH(NEXT_WIDTH),
                    .NUM_INPUTS(NEXT_NUM_INPUTS)
                ) recursive_sum (
                    .data_in(sum_pairs),
                    .sum_out(sum_out)
                );
            end
        endgenerate
    endmodule

    // Instantiate sum_tree for partial_counts
    wire [SUM_WIDTH-1:0] total_sum;
    sum_tree #(
        .INPUT_WIDTH(PARTIAL_WIDTH),
        .NUM_INPUTS(TOTAL_COUNTS)
    ) total_sum_inst (
        .data_in(partial_counts),
        .sum_out(total_sum)
    );

    // Assign output (only 8 bits needed)
    assign out = total_sum[7:0];

endmodule