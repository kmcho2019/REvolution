module popcount5 (
    input  [4:0] in,
    output [3:0] out // max 5 ones, needs 3 bits; 4 bits for safety
);
    // Sum bits explicitly as cascaded adders
    wire [2:0] sum01 = in[0] + in[1]; // 2 bits
    wire [2:0] sum23 = in[2] + in[3]; // 2 bits
    wire [3:0] sum0123 = sum01 + sum23; // 3 bits max (4 max)
    assign out = sum0123 + in[4];       // 4 bits max (5 max)
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Instantiate 51 popcount5 modules for 255 bits (51*5=255)
    wire [3:0] pc_out [50:0]; // each 4 bits output

    genvar i;
    generate
        for (i = 0; i < 51; i = i + 1) begin : gen_popcount5
            popcount5 pc (
                .in(in[i*5 +: 5]),
                .out(pc_out[i])
            );
        end
    endgenerate

    // Balanced adder tree to sum 51 outputs (each 4 bits)
    // Use explicit addition stages with adequate bit widths
    
    // Level 1: sum pairs of pc_out (25 pairs) + 1 leftover (51 is odd)
    wire [5:0] sumL1 [25:0]; // 6 bits: max sum 2*5=10, safe for 6 bits

    genvar j;
    generate
        for (j = 0; j < 25; j = j + 1) begin : gen_sumL1_pairs
            assign sumL1[j] = pc_out[2*j] + pc_out[2*j+1];
        end
    endgenerate
    // Leftover last pc_out[50], zero-extended to 6 bits
    assign sumL1[25] = {2'b00, pc_out[50]};

    // Level 2: sum pairs of sumL1 (13 pairs) (26 elements, actually 26 elements so one leftover)
    wire [6:0] sumL2 [12:0]; // 7 bits: max sum ~20, safe for 7 bits

    generate
        for (j = 0; j < 12; j = j + 1) begin : gen_sumL2_pairs
            assign sumL2[j] = sumL1[2*j] + sumL1[2*j+1];
        end
    endgenerate
    // Leftover sumL1[25]
    assign sumL2[12] = {1'b0, sumL1[25]}; // zero-extend to 7 bits

    // Level 3: sum pairs of sumL2 (6 pairs) + 1 leftover (13 elements)
    wire [7:0] sumL3 [6:0]; // 8 bits: max sum ~40

    generate
        for (j = 0; j < 6; j = j + 1) begin : gen_sumL3_pairs
            assign sumL3[j] = sumL2[2*j] + sumL2[2*j+1];
        end
    endgenerate
    assign sumL3[6] = sumL2[12]; // leftover zero-extended to 8 bits

    // Level 4: sum pairs of sumL3 (3 pairs + 1 leftover (7 elements))
    wire [8:0] sumL4 [3:0]; // 9 bits: max sum ~80

    generate
        for (j = 0; j < 3; j = j + 1) begin : gen_sumL4_pairs
            assign sumL4[j] = sumL3[2*j] + sumL3[2*j+1];
        end
    endgenerate
    assign sumL4[3] = {1'b0, sumL3[6]}; // leftover zero-extended to 9 bits

    // Level 5: sum pairs of sumL4 (2 pairs)
    wire [9:0] sumL5 [1:0]; // 10 bits: max sum ~160

    assign sumL5[0] = sumL4[0] + sumL4[1];
    assign sumL5[1] = sumL4[2] + sumL4[3];

    // Level 6: final sum of last two sums (2 elements)
    wire [10:0] final_sum; // 11 bits: max sum 255

    assign final_sum = sumL5[0] + sumL5[1];

    assign out = final_sum[7:0]; // lower 8 bits sufficient for max 255

endmodule