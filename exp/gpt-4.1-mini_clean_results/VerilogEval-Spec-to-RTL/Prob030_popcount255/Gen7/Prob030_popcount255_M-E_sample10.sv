module popcount8 (
    input  [7:0] in,
    output [4:0] out  // max 8 ones -> 4 bits sufficient, use 5 bits for easy addition
);
    // Simple combinational popcount for 8 bits using addition tree
    wire [3:0] count4_0 = in[3:0][0] + in[3:0][1] + in[3:0][2] + in[3:0][3];
    wire [3:0] count4_1 = in[7:4][0] + in[7:4][1] + in[7:4][2] + in[7:4][3];

    // Count bits individually:
    // But synthesizers handle vector sums well; more explicit tree:
    wire [1:0] sum01 = {1'b0,in[0]} + {1'b0,in[1]};
    wire [2:0] sum23 = {1'b0,in[2]} + {1'b0,in[3]};
    wire [2:0] sum45 = {1'b0,in[4]} + {1'b0,in[5]};
    wire [2:0] sum67 = {1'b0,in[6]} + {1'b0,in[7]};

    wire [2:0] sum0123 = sum01 + sum23; // max 4
    wire [3:0] sum4567 = sum45 + sum67; // max 4

    assign out = sum0123 + sum4567; // max 8, fits in 4 bits, declare 5 bits to be safe
endmodule

module popcount7 (
    input  [6:0] in,
    output [3:0] out  // max 7 ones -> 3 bits sufficient, use 4 bits for addition safety
);
    // Similar logic for 7 bits
    wire [1:0] sum01 = {1'b0,in[0]} + {1'b0,in[1]};
    wire [2:0] sum23 = {1'b0,in[2]} + {1'b0,in[3]};
    wire [2:0] sum45 = {1'b0,in[4]} + {1'b0,in[5]};
    wire sum6 = in[6];

    wire [2:0] sum0123 = sum01 + sum23; // max 4
    wire [3:0] sum45_6 = sum45 + sum6;  // max 4

    assign out = sum0123 + sum45_6; // max 7, fits in 4 bits
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Split input into 31 chunks of 8 bits and 1 chunk of 7 bits
    // Chunk 0 : bits 7:0, chunk 1: bits 15:8, ..., chunk 30: bits 247:240, chunk 31: bits 254:248

    wire [4:0] pcs [0:30]; // popcount8 output per 8-bit chunk (5 bits each)
    wire [3:0] pc_last;    // popcount7 output for last 7 bits

    genvar i;
    generate
        for (i=0; i<31; i=i+1) begin : popcount_chunks
            popcount8 pc8 (
                .in(in[8*i +: 8]),
                .out(pcs[i])
            );
        end
    endgenerate

    popcount7 pc7 (
        .in(in[254:248]),
        .out(pc_last)
    );

    // Now sum all pcs[0..30] (5-bit) + pc_last(4-bit) using balanced adder tree
    // Total count max 255 -> fits in 8 bits

    // Step 1: add pcs in pairs -> 16 wires of 6 bits (max 2*31=62 < 6 bits)
    wire [5:0] sum_level1 [0:15];

    generate
        for (i=0; i<15; i=i+1) begin : sum_level1_loop
            assign sum_level1[i] = pcs[2*i] + pcs[2*i+1];
        end
    endgenerate
    // Last pcs[30] + pc_last
    wire [5:0] last_sum = pcs[30] + {1'b0, pc_last}; // pcs[30] is 5 bits, pc_last 4 bits; zero-extend pc_last

    assign sum_level1[15] = last_sum;

    // Step 2: add sum_level1 pairs -> 8 wires of 7 bits (max ~124 + 62 < 128 fits 7 bits)
    wire [6:0] sum_level2 [0:7];
    generate
        for (i=0; i<8; i=i+1) begin : sum_level2_loop
            assign sum_level2[i] = sum_level1[2*i] + sum_level1[2*i+1];
        end
    endgenerate

    // Step 3: add sum_level2 pairs -> 4 wires of 8 bits
    wire [7:0] sum_level3 [0:3];
    generate
        for (i=0; i<4; i=i+1) begin : sum_level3_loop
            assign sum_level3[i] = sum_level2[2*i] + sum_level2[2*i+1];
        end
    endgenerate

    // Step 4: add sum_level3 pairs -> 2 wires of 9 bits
    wire [8:0] sum_level4 [0:1];
    assign sum_level4[0] = sum_level3[0] + sum_level3[1];
    assign sum_level4[1] = sum_level3[2] + sum_level3[3];

    // Step 5: final add -> 10 bits
    wire [9:0] sum_level5 = sum_level4[0] + sum_level4[1];

    // Output lower 8 bits; max sum is 255 which fits 8 bits
    assign out = sum_level5[7:0];

endmodule