module popcount17 (
    input  [16:0] in,
    output [5:0] out // up to 17 ones => 6 bits
);
    // Stage 1: sum adjacent bits into 8 groups of 2 bits, plus leftover bit
    wire [1:0] sum_pairs [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_sum_pairs
            assign sum_pairs[i] = in[2*i] + in[2*i+1];
        end
    endgenerate
    wire leftover = in[16];

    // Stage 2: sum pairs of sum_pairs (2-bit each), result 3 bits
    wire [2:0] sum_quads [3:0];
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_sum_quads
            assign sum_quads[i] = sum_pairs[2*i] + sum_pairs[2*i+1];
        end
    endgenerate

    // Stage 3: sum pairs of quads (3-bit each), result 4 bits
    wire [3:0] sum_octets [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : gen_sum_octets
            assign sum_octets[i] = sum_quads[2*i] + sum_quads[2*i+1];
        end
    endgenerate

    // Stage 4: sum two octets (4 bits), result 5 bits
    wire [4:0] sum_16 = sum_octets[0] + sum_octets[1];

    // Final: add leftover bit (1 bit) to get total count (6 bits)
    assign out = sum_16 + leftover;

endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    localparam NUM_CHUNKS = 15;
    localparam CHUNK_BITS = 17;

    // Array of partial counts
    wire [5:0] partial_counts [NUM_CHUNKS-1:0];

    genvar idx;
    generate
        for (idx = 0; idx < NUM_CHUNKS; idx = idx + 1) begin : gen_popcounts
            popcount17 pc_inst (
                .in(in[idx*CHUNK_BITS +: CHUNK_BITS]),
                .out(partial_counts[idx])
            );
        end
    endgenerate

    // Hierarchical adder tree to sum 15 counts (6 bits each) to 8-bit out
    // Use a balanced tree approach that reduces the array in stages

    // Helper function to compute log2 ceiling
    function integer clog2;
        input integer val;
        integer v;
        begin
            v = val - 1;
            for (clog2 = 0; v > 0; clog2 = clog2 + 1)
                v = v >> 1;
        end
    endfunction

    // Number of partial sums per stage varies; define a parametric summation
    // We perform iterative summation of pairs, zero-extending properly

    // We'll implement a recursive reduction using a Verilog function (systemverilog would be better, but restricted to verilog)

    // To do iterative reduction, declare regs and always_comb block
    // But since pure combinational is requested, use generate loops and intermediate wires.

    // Calculate max stages needed: ceil(log2(NUM_CHUNKS)) = 4
    localparam STAGES = clog2(NUM_CHUNKS);

    // Stage0 inputs: partial_counts, each 6 bits
    // Subsequent stages: arrays of wires of appropriate width

    // Declare arrays for each stage's sum
    // Max width needed grows as log2 of number of partials times max bit width (6 bits)
    // Max count: 255 (max 0xFF), so 8 bits at output
    // Intermediate sums can safely be 8 bits as well

    // Stage 0: zero-extend partial_counts (6 bits) to 8 bits for summing
    wire [7:0] stage_data [NUM_CHUNKS-1:0];
    generate
        for (idx=0; idx < NUM_CHUNKS; idx=idx+1) begin : gen_stage0_zeroext
            assign stage_data[idx] = {2'b00, partial_counts[idx]};
        end
    endgenerate

    // Declare wires for each stage sums
    // Each stage halves the number of wires; if odd, last one is passed through

    // We'll store all stages in a 2D array of wires for clarity
    // Max stage width is 8 bits for all

    // Using an intermediate array of wires for each stage
    // Stage 0 already assigned to stage_data

    // Stage[i]: number of elements = ceil(NUM_CHUNKS / (2**i))
    // Each element is 8 bits

    // Define all intermediate stage wires:
    // We'll declare wires up to STAGES

    // Declare a macro-like generate construct for all stages from 1 to STAGES:
    // For stage s:
    //   stage_data_s[j] = stage_data_{s-1}[2j] + stage_data_{s-1}[2j+1] if both exist
    //                    else stage_data_{s-1}[2j] if only one element remains

    // To do this in Verilog, we declare wire arrays for each stage.

    // First, declare array of wires for each stage:

    // Stage 0: done, stage_data, size NUM_CHUNKS

    // For stages 1..STAGES, sizes:
    // stage_size = (previous_stage_size + 1) / 2

    // Declare arrays stage1_data, stage2_data ... as wires

    // Implement in generate loops with calculated sizes

    // Sizes per stage:
    // s=0: 15
    // s=1: (15+1)/2=8
    // s=2: (8+1)/2=4
    // s=3: (4+1)/2=2
    // s=4: (2+1)/2=1

    // So stages: 0 to 4 with sizes: 15,8,4,2,1

    wire [7:0] stage1_data [7:0];
    wire [7:0] stage2_data [3:0];
    wire [7:0] stage3_data [1:0];
    wire [7:0] stage4_data [0:0];

    // Assign stage1_data: sum pairs of stage_data
    genvar j;
    generate
        for (j = 0; j < 7; j = j + 1) begin : gen_stage1_sum
            assign stage1_data[j] = stage_data[2*j] + stage_data[2*j + 1];
        end
        // last one unpaired, pass through
        assign stage1_data[7] = stage_data[14];
    endgenerate

    // stage2_data sums pairs of stage1_data (8 elements)
    generate
        for (j = 0; j < 4; j = j + 1) begin : gen_stage2_sum
            assign stage2_data[j] = stage1_data[2*j] + stage1_data[2*j + 1];
        end
    endgenerate

    // stage3_data sums pairs of stage2_data (4 elements)
    generate
        for (j = 0; j < 2; j = j + 1) begin : gen_stage3_sum
            assign stage3_data[j] = stage2_data[2*j] + stage2_data[2*j + 1];
        end
    endgenerate

    // stage4_data sums pairs of stage3_data (2 elements)
    assign stage4_data[0] = stage3_data[0] + stage3_data[1];

    // Final output is stage4_data[0]
    assign out = stage4_data[0];

endmodule