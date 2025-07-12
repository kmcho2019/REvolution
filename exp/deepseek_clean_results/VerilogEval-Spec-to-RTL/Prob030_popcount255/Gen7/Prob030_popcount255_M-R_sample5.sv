module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Level 1: Count 1s in 3-bit chunks (85 chunks)
    wire [1:0] l1 [0:84];  // 2 bits per chunk (max 3)
    integer i;
    for (i = 0; i < 85; i = i + 1) begin
        assign l1[i] = in[i*3] + in[i*3+1] + in[i*3+2];
    end

    // Level 2: Sum 3 level1 counters (28 groups of 3 + 1 leftover)
    wire [3:0] l2 [0:28];  // 4 bits per sum (max 9)
    for (i = 0; i < 28; i = i + 1) begin
        assign l2[i] = l1[i*3] + l1[i*3+1] + l1[i*3+2];
    end
    assign l2[28] = l1[84];  // Last chunk doesn't need zero extension

    // Level 3: Sum 3 level2 counters (9 groups of 3 + 1 leftover)
    wire [5:0] l3 [0:9];  // 6 bits per sum (max 27)
    for (i = 0; i < 9; i = i + 1) begin
        assign l3[i] = l2[i*3] + l2[i*3+1] + l2[i*3+2];
    end
    assign l3[9] = l2[27] + l2[28];  // Combine last two

    // Level 4: Sum 3 level3 counters (3 groups of 3 + 1 leftover)
    wire [7:0] l4 [0:3];  // 8 bits per sum (max 255)
    for (i = 0; i < 3; i = i + 1) begin
        assign l4[i] = l3[i*3] + l3[i*3+1] + l3[i*3+2];
    end
    assign l4[3] = l3[9];  // Last sum

    // Final sum (all level4 results)
    assign out = l4[0] + l4[1] + l4[2] + l4[3];

endmodule