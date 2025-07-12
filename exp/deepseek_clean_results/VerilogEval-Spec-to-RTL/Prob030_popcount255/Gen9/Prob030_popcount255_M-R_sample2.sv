module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // First level: Count bits in 8-bit chunks (except last chunk)
    wire [3:0] count_l1 [0:31];
    
    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : COUNT_8BIT
            assign count_l1[i] = in[i*8+7] + in[i*8+6] + in[i*8+5] + in[i*8+4] +
                                in[i*8+3] + in[i*8+2] + in[i*8+1] + in[i*8];
        end
        // Handle last 7-bit chunk
        assign count_l1[31] = in[254] + in[253] + in[252] + in[251] +
                             in[250] + in[249] + in[248];
    endgenerate

    // Second level: Sum pairs of first level counts (16 sums)
    wire [4:0] count_l2 [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : SUM_L1
            assign count_l2[i] = count_l1[2*i] + count_l1[2*i+1];
        end
    endgenerate

    // Third level: Sum pairs of second level counts (8 sums)
    wire [5:0] count_l3 [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : SUM_L2
            assign count_l3[i] = count_l2[2*i] + count_l2[2*i+1];
        end
    endgenerate

    // Fourth level: Sum pairs of third level counts (4 sums)
    wire [6:0] count_l4 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : SUM_L3
            assign count_l4[i] = count_l3[2*i] + count_l3[2*i+1];
        end
    endgenerate

    // Fifth level: Sum pairs of fourth level counts (2 sums)
    wire [7:0] count_l5 [0:1];
    generate
        for (i = 0; i < 2; i = i + 1) begin : SUM_L4
            assign count_l5[i] = count_l4[2*i] + count_l4[2*i+1];
        end
    endgenerate

    // Final sum
    assign out = count_l5[0] + count_l5[1];

endmodule