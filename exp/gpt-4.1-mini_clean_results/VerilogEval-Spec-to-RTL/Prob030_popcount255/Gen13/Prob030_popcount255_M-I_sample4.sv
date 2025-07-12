module popcount8 (
    input  [7:0] in,
    output [3:0] out
);
    // Count ones in 8 bits
    wire [1:0] sum0, sum1, sum2, sum3;
    assign sum0 = {1'b0, in[0]} + {1'b0, in[1]};
    assign sum1 = {1'b0, in[2]} + {1'b0, in[3]};
    assign sum2 = {1'b0, in[4]} + {1'b0, in[5]};
    assign sum3 = {1'b0, in[6]} + {1'b0, in[7]};
    wire [2:0] sum01 = sum0 + sum1;
    wire [2:0] sum23 = sum2 + sum3;
    assign out = sum01 + sum23; // max 8 (3 bits +)
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Extend input to 256 bits by adding one zero bit
    wire [255:0] in256 = {in, 1'b0};

    // Partial popcounts: 32 groups of 8 bits
    wire [3:0] partial_counts [31:0];
    genvar i;
    generate
        for (i=0; i<32; i=i+1) begin : gen_popcount8
            popcount8 u_popcount8 (
                .in(in256[i*8 +: 8]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    // Sum partial counts in a balanced tree (32 x 4-bit -> final 8-bit output)

    // Level 1: sum pairs -> 16 outputs, each 5 bits max (8 + 8 = max 16)
    wire [4:0] sum_level1 [15:0];
    generate
        for (i=0; i<16; i=i+1) begin : sum_lvl1
            assign sum_level1[i] = partial_counts[2*i] + partial_counts[2*i+1];
        end
    endgenerate

    // Level 2: sum pairs -> 8 outputs, each 6 bits max (16 + 16 = 32)
    wire [5:0] sum_level2 [7:0];
    generate
        for (i=0; i<8; i=i+1) begin : sum_lvl2
            assign sum_level2[i] = sum_level1[2*i] + sum_level1[2*i+1];
        end
    endgenerate

    // Level 3: sum pairs -> 4 outputs, each 7 bits max (32 + 32 = 64)
    wire [6:0] sum_level3 [3:0];
    generate
        for (i=0; i<4; i=i+1) begin : sum_lvl3
            assign sum_level3[i] = sum_level2[2*i] + sum_level2[2*i+1];
        end
    endgenerate

    // Level 4: sum pairs -> 2 outputs, each 8 bits max (64 + 64 = 128)
    wire [7:0] sum_level4 [1:0];
    generate
        for (i=0; i<2; i=i+1) begin : sum_lvl4
            assign sum_level4[i] = sum_level3[2*i] + sum_level3[2*i+1];
        end
    endgenerate

    // Level 5: final sum -> 8 bits max (128 + 127 = 255)
    assign out = sum_level4[0] + sum_level4[1];
endmodule