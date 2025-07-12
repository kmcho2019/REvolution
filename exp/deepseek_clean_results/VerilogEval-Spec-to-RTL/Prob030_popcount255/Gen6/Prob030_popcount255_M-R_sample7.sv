module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Split into 32 groups of 8 bits (last group has 7 bits)
    wire [7:0] partial_counts [0:31];
    
    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : COUNT_8BIT
            assign partial_counts[i] = in[i*8+7] + in[i*8+6] + in[i*8+5] + in[i*8+4] +
                                      in[i*8+3] + in[i*8+2] + in[i*8+1] + in[i*8];
        end
        // Handle last 7-bit group
        assign partial_counts[31] = in[254] + in[253] + in[252] + in[251] +
                                   in[250] + in[249] + in[248];
    endgenerate

    // First level of adder tree (16 adders)
    wire [7:0] sum_level1 [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : LEVEL1
            assign sum_level1[i] = partial_counts[i*2] + partial_counts[i*2+1];
        end
    endgenerate

    // Second level of adder tree (8 adders)
    wire [7:0] sum_level2 [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : LEVEL2
            assign sum_level2[i] = sum_level1[i*2] + sum_level1[i*2+1];
        end
    endgenerate

    // Third level of adder tree (4 adders)
    wire [7:0] sum_level3 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : LEVEL3
            assign sum_level3[i] = sum_level2[i*2] + sum_level2[i*2+1];
        end
    endgenerate

    // Fourth level of adder tree (2 adders)
    wire [7:0] sum_level4 [0:1];
    assign sum_level4[0] = sum_level3[0] + sum_level3[1];
    assign sum_level4[1] = sum_level3[2] + sum_level3[3];

    // Final sum
    assign out = sum_level4[0] + sum_level4[1];

endmodule