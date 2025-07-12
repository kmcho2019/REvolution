module TopModule (
    input  wire [254:0] in,
    output wire [7:0]  out
);

    // Function: Balanced popcount for N bits using recursive balanced addition
    // This function returns [log2(N)+1:0] bits wide result (max count for N bits)
    function automatic [7:0] popcount;
        input integer width;
        input [254:0] data_in;
        integer half;
        reg [7:0] low_sum;
        reg [7:0] high_sum;
        begin
            if (width == 1) begin
                popcount = {7'b0, data_in[0]};
            end else begin
                half = width / 2;
                // Compute popcount recursively on lower half and upper half slices
                low_sum  = popcount(half, data_in[half-1:0]);
                high_sum = popcount(width - half, data_in[width-1:half]);
                popcount = low_sum + high_sum;
            end
        end
    endfunction

    // Since Verilog-2001 does not support passing variable part-selects easily in function,
    // and to keep generate-based combinational logic, we implement popcount with generate.

    // We'll implement a balanced adder tree popcount for fixed widths: 16 and 15 bits.

    // -- 16-bit popcount function
    function [4:0] popcount16_flat;
        input [15:0] bits16;
        reg [1:0] sum2 [7:0];
        reg [2:0] sum4 [3:0];
        reg [3:0] sum8 [1:0];
        integer i;
        begin
            // Level 1: sum every 2 bits
            for (i=0; i<8; i=i+1)
                sum2[i] = bits16[2*i] + bits16[2*i+1];
            // Level 2: sum every 2 pairs (4 bits)
            for (i=0; i<4; i=i+1)
                sum4[i] = sum2[2*i] + sum2[2*i+1];
            // Level 3: sum every 2 quads (8 bits)
            for (i=0; i<2; i=i+1)
                sum8[i] = sum4[2*i] + sum4[2*i+1];
            // Level 4: sum the final two 8-bit sums
            popcount16_flat = sum8[0] + sum8[1];
        end
    endfunction

    // -- 15-bit popcount function (similar, but last slice 15 bits)
    function [3:0] popcount15_flat;
        input [14:0] bits15;
        reg [1:0] sum2 [6:0];
        reg [2:0] sum4 [3:0];
        reg [3:0] sum8;
        integer i;
        begin
            // Level 1: sum every 2 bits, last bit standalone
            for (i=0; i<7; i=i+1)
                sum2[i] = bits15[2*i] + bits15[2*i+1];
            // Level 2: sum pairs of sums; last leftover
            for (i=0; i<3; i=i+1)
                sum4[i] = sum2[2*i] + sum2[2*i+1];
            sum4[3] = sum2[6]; // leftover sum2[6]
            // Level 3: sum first two sum4 pairs
            sum8 = sum4[0] + sum4[1];
            // Level 4: sum sum8 + sum4[2] + sum4[3]
            popcount15_flat = sum8 + sum4[2] + sum4[3];
        end
    endfunction

    // Partial counts for each 16-bit chunk (15 chunks)
    wire [4:0] pc16 [14:0];
    genvar idx;
    generate
        for (idx=0; idx<15; idx=idx+1) begin : gen_popcount16
            wire [15:0] slice16 = in[16*idx +: 16];
            assign pc16[idx] = popcount16_flat(slice16);
        end
    endgenerate

    // Partial count for last 15-bit slice
    wire [3:0] pc15 = popcount15_flat(in[254:240]);

    // Sum all partial counts (15 pc16 + 1 pc15) into final 8-bit output

    // Stage 1: Sum pairs of pc16 (total 15), results 7 sums + 1 leftover pc16[14]
    wire [5:0] sum_stage1 [6:0];
    generate
        for (idx=0; idx<7; idx=idx+1) begin : sum_stage1_pairs
            assign sum_stage1[idx] = pc16[2*idx] + pc16[2*idx+1];
        end
    endgenerate
    wire [4:0] leftover_pc16 = pc16[14];

    // Stage 2: Sum pairs of stage1 sums (7 sums), three pairs + one leftover
    wire [6:0] sum_stage2 [2:0];
    assign sum_stage2[0] = sum_stage1[0] + sum_stage1[1];
    assign sum_stage2[1] = sum_stage1[2] + sum_stage1[3];
    assign sum_stage2[2] = sum_stage1[4] + sum_stage1[5];
    wire [5:0] leftover_stage1 = sum_stage1[6];

    // Stage 3: Sum two of stage2 sums, one leftover remains
    wire [7:0] sum_stage3_0 = sum_stage2[0] + sum_stage2[1];
    wire [6:0] leftover_stage2 = sum_stage2[2];

    // Stage 4: Sum stage3 sums and leftover
    wire [7:0] sum_stage4 = sum_stage3_0 + leftover_stage2;

    // Add leftover sums and pc15
    wire [8:0] sum_add_leftovers = sum_stage4 + leftover_stage1 + leftover_pc16 + {5'b0, pc15};

    // Final output: lower 8 bits (max sum 255 fits in 8 bits)
    assign out = sum_add_leftovers[7:0];

endmodule