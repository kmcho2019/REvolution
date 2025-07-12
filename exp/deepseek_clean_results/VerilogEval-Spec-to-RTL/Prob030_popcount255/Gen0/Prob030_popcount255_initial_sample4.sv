module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // First level: count '1's in 3-bit chunks (85 chunks total)
    wire [6:0] level1 [0:84];
    genvar i;
    generate
        for (i = 0; i < 85; i = i + 1) begin : level1_counters
            if (i < 84) begin
                // Full 3-bit chunks
                assign level1[i] = in[i*3] + in[i*3+1] + in[i*3+2];
            end else begin
                // Last chunk (only 3 bits: 252-254)
                assign level1[i] = in[i*3] + in[i*3+1] + in[i*3+2];
            end
        end
    endgenerate

    // Second level: sum 3 level1 counters (28 groups of 3, 1 group of 1)
    wire [7:0] level2 [0:28];
    generate
        for (i = 0; i < 28; i = i + 1) begin : level2_adders
            assign level2[i] = level1[i*3] + level1[i*3+1] + level1[i*3+2];
        end
        // Last group has only 1 counter (from 84 counters: 28*3=84)
        assign level2[28] = level1[84];
    endgenerate

    // Third level: sum level2 counters (9 groups of 3, 1 group of 2)
    wire [7:0] level3 [0:9];
    generate
        for (i = 0; i < 9; i = i + 1) begin : level3_adders
            assign level3[i] = level2[i*3] + level2[i*3+1] + level2[i*3+2];
        end
        // Last group has 2 counters (from 29 counters: 9*3+2=29)
        assign level3[9] = level2[27] + level2[28];
    endgenerate

    // Fourth level: sum level3 counters (3 groups of 3, 1 group of 1)
    wire [7:0] level4 [0:3];
    generate
        for (i = 0; i < 3; i = i + 1) begin : level4_adders
            assign level4[i] = level3[i*3] + level3[i*3+1] + level3[i*3+2];
        end
        // Last group has 1 counter (from 10 counters: 3*3+1=10)
        assign level4[3] = level3[9];
    endgenerate

    // Fifth level: sum level4 counters (1 group of 4)
    wire [7:0] level5;
    assign level5 = level4[0] + level4[1] + level4[2] + level4[3];

    // Final output
    assign out = level5;

endmodule