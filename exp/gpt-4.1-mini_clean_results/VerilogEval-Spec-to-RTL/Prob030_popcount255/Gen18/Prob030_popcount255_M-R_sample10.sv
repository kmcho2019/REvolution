module popcount8 (
    input  [7:0] in,
    output [3:0] out // max count 8 fits in 4 bits
);
    // Balanced explicit adder tree for 8 bits
    wire [1:0] sum_l1 [3:0];
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : l1
            assign sum_l1[i] = in[2*i] + in[2*i+1];
        end
    endgenerate

    wire [2:0] sum_l2 [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : l2
            assign sum_l2[i] = sum_l1[2*i] + sum_l1[2*i+1];
        end
    endgenerate

    assign out = sum_l2[0] + sum_l2[1];
endmodule


module popcount255 (
    input  [254:0] in,
    output [7:0] out
);
    localparam CHUNK_SIZE = 8;
    localparam NUM_CHUNKS = (255 + CHUNK_SIZE - 1) / CHUNK_SIZE; // 32 chunks (last partial)
    localparam MAX_CHUNKS = NUM_CHUNKS;
    // Each chunk outputs 4 bits (popcount8 output)
    wire [3:0] chunk_counts [0:MAX_CHUNKS-1];

    genvar idx;
    generate
        for (idx = 0; idx < MAX_CHUNKS; idx = idx + 1) begin : chunk_popcount
            wire [7:0] chunk_in;
            if (idx == MAX_CHUNKS-1) begin
                // Last chunk may have fewer than 8 bits; pad zeros MSBs
                localparam LAST_CHUNK_WIDTH = 255 - idx * CHUNK_SIZE;
                assign chunk_in = { {(8-LAST_CHUNK_WIDTH){1'b0}}, in[255-1 - idx*CHUNK_SIZE -: LAST_CHUNK_WIDTH] };
            end else begin
                assign chunk_in = in[(idx+1)*CHUNK_SIZE-1 -: CHUNK_SIZE];
            end
            popcount8 pc8 (
                .in(chunk_in),
                .out(chunk_counts[idx])
            );
        end
    endgenerate

    // Now sum the chunk_counts in a balanced binary tree to get final count
    // Each partial sum width grows by 1 bit after each addition
    // Start with all counts 4 bits wide, sum pairwise, repeat until 1 output

    // Function to calculate the ceiling of log2 of integer n
    function integer clog2(input integer n);
        integer k;
        begin
            k = 0;
            while ((2**k) < n)
                k = k + 1;
            clog2 = k;
        end
    endfunction

    // Number of partial sums at current stage
    localparam integer STAGE0_WIDTH = 4; // chunk_counts bits width
    localparam integer STAGE0_CNT = MAX_CHUNKS;

    // Maximum stages needed = clog2(MAX_CHUNKS)
    localparam integer MAX_STAGES = clog2(MAX_CHUNKS);

    // Define storage for sums at each stage:
    // Using generate block arrays of wires

    // We will use a two-dimensional array of wires:
    // stage_sums[stage][index]

    // Each stage sum width grows by 1 compared to previous stage

    // Since Verilog doesn't support multi-dimensional packed arrays for wires,
    // use arrays of wires with width per stage.

    // Declare stage sums arrays
    // stage 0 sums = chunk_counts, width 4
    // stage 1 sums = sums of pairs of stage0 sums, width 5
    // ...
    // stage MAX_STAGES sums = final single output, width 4 + MAX_STAGES

    // Maximum elements at each stage:
    // ceil(stage0_cnt/2^stage)

    // Define widths per stage:
    // width(stage) = 4 + stage

    // We create one extra stage if needed for odd elements

    // We'll implement the summation tree with generate loops

    // Stage sums declaration: array of wires [width-1:0]

    // Create packed arrays for each stage
    // Due to Verilog limitations, define wires for each stage with max possible elements

    // Stage 0 wires - assign chunk_counts directly

    // Stage 1 onwards: wires generated and assigned from sums of previous stage

    // Intermediate arrays:
    // Stage i count = (Stage i-1 count + 1) / 2

    // Define sizes at each stage
    integer stage_counts [0:MAX_STAGES];
    initial begin
        stage_counts[0] = STAGE0_CNT;
        integer s;
        for (s=1; s<=MAX_STAGES; s=s+1) begin
            stage_counts[s] = (stage_counts[s-1] + 1) / 2;
        end
    end

    // Unfortunately initial block and variables cannot be used directly for parameters in generate
    // Use localparams with functions or define stage counts via a function

    function integer stage_count;
        input integer stage;
        integer sc0;
        integer i;
        begin
            sc0 = STAGE0_CNT;
            for (i=1; i<=stage; i=i+1)
                sc0 = (sc0 + 1) / 2;
            stage_count = sc0;
        end
    endfunction

    // Declare wires for each stage sums
    // To handle variable widths and array sizes, unroll generate loops for each stage

    // stage 0 sums wires = chunk_counts [already declared]

    // Now declare sums for stages 1..MAX_STAGES
    genvar stage, elem;
    // For stage sums, create wires
    // Max width at stage s: 4 + s

    // Declare wires for stage sums:
    // Use generate blocks and arrays of wires for each stage

    // This implementation declares wires using generate, and assigns sums by addition.

    // We'll create a two-level generate loop:
    // outer: stage = 1..MAX_STAGES
    // inner: index within stage sums

    // Since stage_counts is a function, use that inside generate blocks

    // Also, stage 0 sums are chunk_counts (4-bit width)

    // Stage 0 sums are the base, so no wire declaration needed.

    // For stage >=1, declare wires stage_sums_s<stage>[0:stage_count(stage)-1]

    // To hold all stage sums, use generate blocks with localparams to get counts

    // Declare all stage sums as packed wires inside generate blocks

    // Use a two-level generate loops to assign sums for each stage

    // For stage 1 to MAX_STAGES:
    // Each sum is sum of two previous sums (or just one if odd count)

    // Create a wrapper module to hold sums at each stage

    // Let's implement now:

    // Stage sums arrays - declare as generate variables

    // We use localparams and defines for sizes and widths inside generate

    // Final output width = 4 + MAX_STAGES

    // For neatness, use a generate block hierarchy to declare wires and assign sums


    // -----------------------------------
    // Implementation of summation tree below
    // -----------------------------------

    // Stage sums: 
    // stage_sums[stage][index]: width = 4 + stage

    // Stage 0 sums: chunk_counts (4 bits), already wires

    // Create 2D array of wires stage_sums for stage >=1

    // Due to Verilog limitations, create wires with generated names in generate blocks

    // Create a module internal function to get width for stage
    function integer width_for_stage(input integer stage);
        width_for_stage = 4 + stage;
    endfunction

    // Signals to hold sums at each stage (except stage 0 which is chunk_counts)
    // Use generate loops to create wires and assign sums

    // Declare the wires in nested generate:

    // Declare a reg for final output after last stage sum wire (will assign to out)

    // Declare wires for each stage sums

    // Can't declare arrays of vectors in Verilog, so declare individual wires in arrays via generate

    // Create wire arrays stage_sums_s1, stage_sums_s2, ... stage_sums_sN

    // This requires unrolling generate for each stage, up to MAX_STAGES.

    // We'll implement stages one by one for clarity

    // Save stage sums of previous stage in wires for current stage sums

    // Declare intermediate signals:

    // For stage 1 sums
    wire [width_for_stage(1)-1:0] stage1_sums [0:stage_count(1)-1];
    // Stage 2 sums
    wire [width_for_stage(2)-1:0] stage2_sums [0:stage_count(2)-1];
    // Stage 3 sums
    wire [width_for_stage(3)-1:0] stage3_sums [0:stage_count(3)-1];
    // Stage 4 sums
    wire [width_for_stage(4)-1:0] stage4_sums [0:stage_count(4)-1];
    // Stage 5 sums
    wire [width_for_stage(5)-1:0] stage5_sums [0:stage_count(5)-1];
    // MAX_STAGES is ceil(log2(32))=5, so we cover up to stage 5.

    // Assignments for stage 1 sums: sum pairs of chunk_counts (stage 0)
    // Each sum = zero extend 4-bit previous sums to 5-bit and add

    // Proceed similarly for other stages

    // Finally assign final sum (stage MAX_STAGES sums [0]) to output

    // Implementation:

    // Stage 1 sums
    generate
        for (elem = 0; elem < stage_count(1); elem = elem + 1) begin : stage1
            // Indices of chunk_counts to sum: 2*elem and 2*elem+1
            wire [4:0] left = {1'b0, chunk_counts[2*elem]};
            wire [4:0] right = (2*elem+1 < stage_count(0)) ? {1'b0, chunk_counts[2*elem+1]} : 5'b0;
            assign stage1_sums[elem] = left + right;
        end
    endgenerate

    // Stage 2 sums
    generate
        for (elem = 0; elem < stage_count(2); elem = elem + 1) begin : stage2
            wire [5:0] left = {1'b0, stage1_sums[2*elem]};
            wire [5:0] right = (2*elem+1 < stage_count(1)) ? {1'b0, stage1_sums[2*elem+1]} : 6'b0;
            assign stage2_sums[elem] = left + right;
        end
    endgenerate

    // Stage 3 sums
    generate
        for (elem = 0; elem < stage_count(3); elem = elem + 1) begin : stage3
            wire [6:0] left = {1'b0, stage2_sums[2*elem]};
            wire [6:0] right = (2*elem+1 < stage_count(2)) ? {1'b0, stage2_sums[2*elem+1]} : 7'b0;
            assign stage3_sums[elem] = left + right;
        end
    endgenerate

    // Stage 4 sums
    generate
        for (elem = 0; elem < stage_count(4); elem = elem + 1) begin : stage4
            wire [7:0] left = {1'b0, stage3_sums[2*elem]};
            wire [7:0] right = (2*elem+1 < stage_count(3)) ? {1'b0, stage3_sums[2*elem+1]} : 8'b0;
            assign stage4_sums[elem] = left + right;
        end
    endgenerate

    // Stage 5 sums
    generate
        for (elem = 0; elem < stage_count(5); elem = elem + 1) begin : stage5
            wire [8:0] left = {1'b0, stage4_sums[2*elem]};
            wire [8:0] right = (2*elem+1 < stage_count(4)) ? {1'b0, stage4_sums[2*elem+1]} : 9'b0;
            assign stage5_sums[elem] = left + right;
        end
    endgenerate

    // Assign final output:
    // stage_count(5) is 1, so stage5_sums[0] is final sum width 9 bits
    // But out port is 8 bits wide, so truncate or reduce width carefully.

    // Max popcount of 255 bits is 255 (0xFF), fits in 8 bits unsigned.

    // Our sum width at stage 5 is 9 bits, so safely assign out = stage5_sums[0][7:0]

    // If stage5_sums is not single element (in theory it is), but safe to confirm.

    // If MAX_STAGES <5 (for less chunks), choose last stage dynamically.

    // Here MAX_STAGES=5 for 32 chunks

    assign out = stage5_sums[0][7:0];

endmodule


module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Directly instantiate popcount255 module
    popcount255 u_popcount (
        .in(in),
        .out(out)
    );
endmodule