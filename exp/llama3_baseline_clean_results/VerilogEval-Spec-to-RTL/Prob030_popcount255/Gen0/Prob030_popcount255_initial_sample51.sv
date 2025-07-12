module TopModule(
    input  [254:0] in,
    output [7:0] out
);

    // Initialize a wire to store the population count
    wire [7:0] count;

    // Population count for 16-bit chunks
    wire [4:0] chunk_count [15:0];

    // Population count for 7-bit chunk
    wire [2:0] chunk_count_last;

    // Count the number of '1's in each 16-bit chunk
    genvar i;
    generate
        for (i = 0; i < 15; i++) begin
            // Use a 16-bit population count circuit
            PopCount16 pop_count_i (
                .in(in[i*16 +: 16]),
                .out(chunk_count[i])
            );
        end
    endgenerate

    // Count the number of '1's in the last 7-bit chunk
    PopCount7 pop_count_last (
        .in(in[240 +: 7]),
        .out(chunk_count_last)
    );

    // Sum up the counts using a tree-like structure
    wire [4:0] sum0 [7:0];
    wire [5:0] sum1 [3:0];
    wire [6:0] sum2 [1:0];
    wire [7:0] sum3;

    // Level 0 of the tree
    assign sum0[0] = chunk_count[0] + chunk_count[1];
    assign sum0[1] = chunk_count[2] + chunk_count[3];
    assign sum0[2] = chunk_count[4] + chunk_count[5];
    assign sum0[3] = chunk_count[6] + chunk_count[7];
    assign sum0[4] = chunk_count[8] + chunk_count[9];
    assign sum0[5] = chunk_count[10] + chunk_count[11];
    assign sum0[6] = chunk_count[12] + chunk_count[13];
    assign sum0[7] = chunk_count[14] + chunk_count_last;

    // Level 1 of the tree
    assign sum1[0] = sum0[0] + sum0[1];
    assign sum1[1] = sum0[2] + sum0[3];
    assign sum1[2] = sum0[4] + sum0[5];
    assign sum1[3] = sum0[6] + sum0[7];

    // Level 2 of the tree
    assign sum2[0] = sum1[0] + sum1[1];
    assign sum2[1] = sum1[2] + sum1[3];

    // Level 3 of the tree
    assign sum3 = sum2[0] + sum2[1];

    // Assign the final count to the output
    assign out = sum3[7:0];

endmodule

// 16-bit population count circuit
module PopCount16(
    input  [15:0] in,
    output [4:0] out
);

    wire [4:0] count;

    assign count = in[0] + in[1] + in[2] + in[3] +
                   in[4] + in[5] + in[6] + in[7] +
                   in[8] + in[9] + in[10] + in[11] +
                   in[12] + in[13] + in[14] + in[15];

    assign out = count;

endmodule

// 7-bit population count circuit
module PopCount7(
    input  [6:0] in,
    output [2:0] out
);

    wire [2:0] count;

    assign count = in[0] + in[1] + in[2] + in[3] +
                   in[4] + in[5] + in[6];

    assign out = count;

endmodule