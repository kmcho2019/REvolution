module popcount #(
    parameter WIDTH = 17
) (
    input  wire [WIDTH-1:0] in,
    output wire [$clog2(WIDTH+1)-1:0] out
);
    // Recursive pairwise summation using generate to count bits
    // Level-wise summation reducing the vector size until single count remains

    localparam OUT_WIDTH = $clog2(WIDTH+1);

    // Stage arrays: each stage halves the width by summing pairs
    // We'll create a packed array of sums at each stage
    // Start with sums of single bits (0 or 1), then sum pairs, etc.

    // Calculate number of stages: ceil(log2(WIDTH))
    localparam STAGES = $clog2(WIDTH);

    // We'll store intermediate sums in a generate loop using an array of wires.
    // Each stage width is ceil(WIDTH / 2^stage)
    // Since WIDTH may be odd, handle the odd element by adding zero.

    // Declare a memory for each stage of sums:
    wire [OUT_WIDTH-1:0] sums [0:STAGES][];
    // In Verilog we can't declare variable-length arrays directly for wires.
    // So we implement sums using localparams and generate loops.

    // Instead, implement the summation stages in a recursive function.

    function [OUT_WIDTH-1:0] popcount_func;
        input integer length;
        input [WIDTH-1:0] bits;
        integer i;
        reg [OUT_WIDTH-1:0] sum;
        begin
            if (length == 1) begin
                popcount_func = bits[0];
            end else begin
                sum = 0;
                for (i = 0; i < length; i = i + 2) begin
                    if (i+1 < length)
                        sum = sum + bits[i +: 2]; // sum of two bits (0-2)
                    else
                        sum = sum + bits[i]; // last odd bit
                end
                // Recursively call popcount_func with half length (rounded up)
                popcount_func = popcount_func((length+1)/2, sum);
            end
        end
    endfunction

    assign out = popcount_func(WIDTH, in);

endmodule


module TopModule (
    input  wire [254:0] in,
    output wire [7:0] out
);
    // Number of chunks = 15 (each 17 bits)
    localparam NUM_CHUNKS = 15;
    localparam CHUNK_WIDTH = 17;

    // Partial counts outputs (6 bits each since max 17 ones)
    wire [5:0] partial_counts [NUM_CHUNKS-1:0];

    genvar i;
    generate
        for (i = 0; i < NUM_CHUNKS; i = i + 1) begin : gen_popcount
            popcount #(CHUNK_WIDTH) pc_inst (
                .in(in[i*CHUNK_WIDTH +: CHUNK_WIDTH]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    // Balanced adder tree summation of partial_counts (15 x 6 bits)

    // Level 1: sum pairs (7 sums), one leftover
    wire [7:0] level1 [7:0];
    assign level1[0] = partial_counts[0] + partial_counts[1]; // max 34 -> 6 bits + 6 bits +1 bit => 7 bits safe, use 8 bits for convenience
    assign level1[1] = partial_counts[2] + partial_counts[3];
    assign level1[2] = partial_counts[4] + partial_counts[5];
    assign level1[3] = partial_counts[6] + partial_counts[7];
    assign level1[4] = partial_counts[8] + partial_counts[9];
    assign level1[5] = partial_counts[10] + partial_counts[11];
    assign level1[6] = partial_counts[12] + partial_counts[13];
    assign level1[7] = {{2{1'b0}}, partial_counts[14]}; // zero-extend last one to 8 bits

    // Level 2: sum pairs (4 sums)
    wire [8:0] level2 [3:0]; // max 34+34=68 < 2^7; sum of two 8-bit numbers up to 255, so 9 bits safe
    assign level2[0] = level1[0] + level1[1];
    assign level2[1] = level1[2] + level1[3];
    assign level2[2] = level1[4] + level1[5];
    assign level2[3] = level1[6] + level1[7];

    // Level 3: sum pairs (2 sums)
    wire [9:0] level3 [1:0]; // sums up to 2*255=510, need 9 bits min, use 10 bits for safety
    assign level3[0] = level2[0] + level2[1];
    assign level3[1] = level2[2] + level2[3];

    // Level 4: final sum
    wire [10:0] final_sum; // up to 2*510=1020, 11 bits safe
    assign final_sum = level3[0] + level3[1];

    assign out = final_sum[7:0]; // Truncate upper bits because max population count = 255 < 256 fits in 8 bits

endmodule