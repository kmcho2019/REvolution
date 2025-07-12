module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Level 1: Count 1s in 8-bit chunks (3-bit results)
    wire [2:0] l1 [0:31];
    
    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : COUNT_8BIT
            assign l1[i] = in[i*8+7] + in[i*8+6] + in[i*8+5] + in[i*8+4] +
                          in[i*8+3] + in[i*8+2] + in[i*8+1] + in[i*8];
        end
        // Last 7-bit chunk
        assign l1[31] = in[254] + in[253] + in[252] + in[251] +
                       in[250] + in[249] + in[248];
    endgenerate

    // Level 2: Sum pairs (4-bit results)
    wire [3:0] l2 [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : LEVEL2
            assign l2[i] = l1[i*2] + l1[i*2+1];
        end
    endgenerate

    // Level 3: Sum pairs (5-bit results)
    wire [4:0] l3 [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : LEVEL3
            assign l3[i] = l2[i*2] + l2[i*2+1];
        end
    endgenerate

    // Level 4: Sum pairs (6-bit results)
    wire [5:0] l4 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : LEVEL4
            assign l4[i] = l3[i*2] + l3[i*2+1];
        end
    endgenerate

    // Final level: Sum remaining (8-bit result)
    assign out = l4[0] + l4[1] + l4[2] + l4[3];

endmodule