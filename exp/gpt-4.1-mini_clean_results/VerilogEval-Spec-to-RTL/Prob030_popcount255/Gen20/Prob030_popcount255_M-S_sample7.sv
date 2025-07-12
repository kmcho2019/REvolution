module popcount8 (
    input  [7:0] in,
    output [4:0] out // max 8 -> 4 bits, 5 bits for safety
);
    // Count bits using simple adder tree
    wire [1:0] s0 = in[0] + in[1];
    wire [1:0] s1 = in[2] + in[3];
    wire [1:0] s2 = in[4] + in[5];
    wire [1:0] s3 = in[6] + in[7];

    wire [2:0] s4 = s0 + s1;
    wire [2:0] s5 = s2 + s3;

    assign out = s4 + s5; // max 8
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Zero-pad to 256 bits for convenient grouping into 32 bytes
    wire [255:0] in_pad = {1'b0, in};

    // Step 1: Count bits in each 8-bit chunk
    wire [4:0] partial_counts[31:0];
    genvar i;
    generate
        for (i=0; i<32; i=i+1) begin : popcount_bytes
            popcount8 u_pc8 (
                .in(in_pad[8*i +: 8]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    // Step 2: Sum 32 partial counts iteratively in a balanced binary tree
    // Level widths:
    // 32 -> 16 -> 8 -> 4 -> 2 -> 1 sums

    // Level 1: sum pairs of 5-bit partial counts -> 6 bits max (max 16)
    wire [5:0] sum_level1[15:0];
    for (i=0; i<16; i=i+1) begin : level1
        assign sum_level1[i] = partial_counts[2*i] + partial_counts[2*i+1];
    end

    // Level 2: sum pairs of 6-bit values -> 7 bits max (max 32)
    wire [6:0] sum_level2[7:0];
    for (i=0; i<8; i=i+1) begin : level2
        assign sum_level2[i] = sum_level1[2*i] + sum_level1[2*i+1];
    end

    // Level 3: sum pairs of 7-bit values -> 8 bits max (max 64)
    wire [7:0] sum_level3[3:0];
    for (i=0; i<4; i=i+1) begin : level3
        assign sum_level3[i] = sum_level2[2*i] + sum_level2[2*i+1];
    end

    // Level 4: sum pairs of 8-bit values -> 8 bits max (max 128)
    wire [7:0] sum_level4[1:0];
    for (i=0; i<2; i=i+1) begin : level4
        assign sum_level4[i] = sum_level3[2*i] + sum_level3[2*i+1];
    end

    // Level 5: final sum of two 8-bit values -> 8 bits max (max 255)
    assign out = sum_level4[0] + sum_level4[1];

endmodule