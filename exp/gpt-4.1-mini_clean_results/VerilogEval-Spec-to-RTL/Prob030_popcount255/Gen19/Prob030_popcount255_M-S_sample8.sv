module popcount32 (
    input  [31:0] in,
    output [6:0] out // 7 bits for sum up to 32
);
    // Level 1: sum pairs of bits (2-bit results)
    wire [1:0] s0 = in[0] + in[1];
    wire [1:0] s1 = in[2] + in[3];
    wire [1:0] s2 = in[4] + in[5];
    wire [1:0] s3 = in[6] + in[7];
    wire [1:0] s4 = in[8] + in[9];
    wire [1:0] s5 = in[10] + in[11];
    wire [1:0] s6 = in[12] + in[13];
    wire [1:0] s7 = in[14] + in[15];
    wire [1:0] s8 = in[16] + in[17];
    wire [1:0] s9 = in[18] + in[19];
    wire [1:0] s10 = in[20] + in[21];
    wire [1:0] s11 = in[22] + in[23];
    wire [1:0] s12 = in[24] + in[25];
    wire [1:0] s13 = in[26] + in[27];
    wire [1:0] s14 = in[28] + in[29];
    wire [1:0] s15 = in[30] + in[31];

    // Level 2: sum pairs of 2-bit values (3-bit results)
    wire [2:0] t0 = s0 + s1;
    wire [2:0] t1 = s2 + s3;
    wire [2:0] t2 = s4 + s5;
    wire [2:0] t3 = s6 + s7;
    wire [2:0] t4 = s8 + s9;
    wire [2:0] t5 = s10 + s11;
    wire [2:0] t6 = s12 + s13;
    wire [2:0] t7 = s14 + s15;

    // Level 3: sum pairs of 3-bit values (4-bit results)
    wire [3:0] u0 = t0 + t1;
    wire [3:0] u1 = t2 + t3;
    wire [3:0] u2 = t4 + t5;
    wire [3:0] u3 = t6 + t7;

    // Level 4: sum pairs of 4-bit values (5-bit results)
    wire [4:0] v0 = u0 + u1;
    wire [4:0] v1 = u2 + u3;

    // Level 5: sum two 5-bit values (6-bit result)
    wire [5:0] w0 = v0 + v1;

    // Output: sum fits in 7 bits
    assign out = w0;
endmodule

module popcount31 (
    input  [30:0] in,
    output [6:0] out // 7 bits for sum up to 31
);
    // Similar structure to popcount32, last bit handled separately
    wire [1:0] s0 = in[0] + in[1];
    wire [1:0] s1 = in[2] + in[3];
    wire [1:0] s2 = in[4] + in[5];
    wire [1:0] s3 = in[6] + in[7];
    wire [1:0] s4 = in[8] + in[9];
    wire [1:0] s5 = in[10] + in[11];
    wire [1:0] s6 = in[12] + in[13];
    wire [1:0] s7 = in[14] + in[15];
    wire [1:0] s8 = in[16] + in[17];
    wire [1:0] s9 = in[18] + in[19];
    wire [1:0] s10 = in[20] + in[21];
    wire [1:0] s11 = in[22] + in[23];
    wire [1:0] s12 = in[24] + in[25];
    wire [1:0] s13 = in[26] + in[27];
    wire [1:0] s14 = in[28] + in[29];
    wire leftover = in[30];

    wire [2:0] t0 = s0 + s1;
    wire [2:0] t1 = s2 + s3;
    wire [2:0] t2 = s4 + s5;
    wire [2:0] t3 = s6 + s7;
    wire [2:0] t4 = s8 + s9;
    wire [2:0] t5 = s10 + s11;
    wire [2:0] t6 = s12 + s13;
    wire [2:0] t7 = s14 + leftover; // Add leftover bit here

    wire [3:0] u0 = t0 + t1;
    wire [3:0] u1 = t2 + t3;
    wire [3:0] u2 = t4 + t5;
    wire [3:0] u3 = t6 + t7;

    wire [4:0] v0 = u0 + u1;
    wire [4:0] v1 = u2 + u3;

    wire [5:0] w0 = v0 + v1;

    assign out = w0;
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Partition input: 8 chunks of 32 bits + 1 chunk of 31 bits
    wire [6:0] counts32 [0:7];
    wire [6:0] count31;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pc32_blocks
            popcount32 pc32 (
                .in(in[i*32 +: 32]),
                .out(counts32[i])
            );
        end
    endgenerate

    popcount31 pc31 (
        .in(in[255 - 31: 255 - 31 - 30]), // bits 224 to 254 (31 bits)
        .out(count31)
    );

    // Sum all partial counts with simple additions
    // sum counts32[0..7] + count31
    wire [10:0] sum0 = counts32[0] + counts32[1] + counts32[2] + counts32[3];
    wire [10:0] sum1 = counts32[4] + counts32[5] + counts32[6] + counts32[7];

    wire [11:0] sum2 = sum0 + sum1;
    wire [12:0] total_sum = sum2 + count31;

    assign out = total_sum[7:0]; // 8 bits enough since max is 255
endmodule