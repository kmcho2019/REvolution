module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Level 1: Count '1's in 3-bit chunks (85 chunks)
    wire [1:0] level1 [0:84];
    genvar i;
    generate
        for (i = 0; i < 85; i = i + 1) begin : level1_counters
            localparam start = i*3;
            wire [2:0] group = (start+2 <= 254) ? in[start +: 3] : 
                              {in[start], (start+1 <= 254) ? in[start+1] : 1'b0, 1'b0};
            assign level1[i] = group[0] + group[1] + group[2];
        end
    endgenerate

    // Level 2: Sum 4 level1 counters (21 groups of 4, 1 leftover)
    wire [3:0] level2 [0:21];
    generate
        for (i = 0; i < 21; i = i + 1) begin : level2_adders
            assign level2[i] = level1[i*4] + level1[i*4+1] + 
                             level1[i*4+2] + level1[i*4+3];
        end
        // Handle leftover (1 counter)
        assign level2[21] = level1[84];
    endgenerate

    // Level 3: Sum 4 level2 counters (5 groups of 4, 2 leftovers)
    wire [5:0] level3 [0:6];
    generate
        for (i = 0; i < 5; i = i + 1) begin : level3_adders
            assign level3[i] = level2[i*4] + level2[i*4+1] + 
                              level2[i*4+2] + level2[i*4+3];
        end
        // Handle leftovers (2 counters)
        assign level3[5] = level2[20] + level2[21];
    endgenerate

    // Level 4: Sum level3 counters (balanced binary tree)
    wire [6:0] level4_0 = level3[0] + level3[1];
    wire [6:0] level4_1 = level3[2] + level3[3];
    wire [6:0] level4_2 = level3[4] + level3[5];
    
    // Final sum
    wire [7:0] sum = level4_0 + level4_1 + level4_2;

    assign out = sum;

endmodule