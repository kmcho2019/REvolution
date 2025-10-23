module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Level 1: Count '1's in 3-bit chunks (85 chunks)
    wire [1:0] level1 [0:84];
    genvar i;
    generate
        for (i = 0; i < 85; i = i + 1) begin : level1_counters
            assign level1[i] = in[i*3] + in[i*3+1] + in[i*3+2];
        end
    endgenerate

    // Level 2: Sum 3 level1 counters (28 groups of 3 + 1 padded zero)
    wire [3:0] level2 [0:28];
    generate
        for (i = 0; i < 28; i = i + 1) begin : level2_adders
            assign level2[i] = level1[i*3] + level1[i*3+1] + level1[i*3+2];
        end
        // Pad with zero to make complete group
        assign level2[28] = 2'b0;
    endgenerate

    // Level 3: Sum 3 level2 counters (9 groups of 3 + 2 padded zeros)
    wire [5:0] level3 [0:10];
    generate
        for (i = 0; i < 9; i = i + 1) begin : level3_adders
            assign level3[i] = level2[i*3] + level2[i*3+1] + level2[i*3+2];
        end
        // Pad with zeros to make complete group
        assign level3[9] = 4'b0;
        assign level3[10] = 4'b0;
    endgenerate

    // Level 4: Sum 3 level3 counters (3 groups of 3 + 2 padded zeros)
    wire [7:0] level4 [0:4];
    generate
        for (i = 0; i < 3; i = i + 1) begin : level4_adders
            assign level4[i] = level3[i*3] + level3[i*3+1] + level3[i*3+2];
        end
        // Pad with zeros to make complete group
        assign level4[3] = 6'b0;
        assign level4[4] = 6'b0;
    endgenerate

    // Final level: Single 4-input adder
    assign out = level4[0] + level4[1] + level4[2] + level4[3];

endmodule