module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Level 1: Count '1's in 3-bit chunks (85 chunks)
    wire [1:0] level1 [0:84];
    integer i;
    always_comb begin
        for (i = 0; i < 85; i = i + 1) begin
            automatic integer start = i*3;
            automatic logic [2:0] group = (start+2 <= 254) ? in[start +: 3] : 
                                         {in[start], (start+1 <= 254) ? in[start+1] : 1'b0, 1'b0};
            level1[i] = group[0] + group[1] + group[2];
        end
    end

    // Level 2: Sum 4 level1 counters (21 groups of 4, 1 leftover)
    wire [3:0] level2 [0:21];
    always_comb begin
        for (i = 0; i < 21; i = i + 1) begin
            level2[i] = level1[i*4] + level1[i*4+1] + level1[i*4+2] + level1[i*4+3];
        end
        level2[21] = level1[84];  // Last leftover
    end

    // Level 3: Sum level2 counters (5 groups of 4, 2 leftovers)
    wire [5:0] level3 [0:6];
    always_comb begin
        for (i = 0; i < 5; i = i + 1) begin
            level3[i] = level2[i*4] + level2[i*4+1] + level2[i*4+2] + level2[i*4+3];
        end
        level3[5] = level2[20] + level2[21];  // Last two leftovers
    end

    // Final balanced binary tree summation
    wire [6:0] sum01 = level3[0] + level3[1];
    wire [6:0] sum23 = level3[2] + level3[3];
    wire [6:0] sum45 = level3[4] + level3[5];
    wire [7:0] total = sum01 + sum23 + sum45;

    assign out = total;

endmodule