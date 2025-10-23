module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Count '1's in each 8-bit chunk (32 chunks total, last chunk is 7 bits)
    wire [3:0] partial_counts [0:31];
    
    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : COUNT_8BIT
            assign partial_counts[i] = in[i*8+7] + in[i*8+6] + in[i*8+5] + in[i*8+4] +
                                     in[i*8+3] + in[i*8+2] + in[i*8+1] + in[i*8];
        end
        // Handle the last 7-bit chunk
        assign partial_counts[31] = in[254] + in[253] + in[252] + in[251] +
                                  in[250] + in[249] + in[248];
    endgenerate

    // Sum all partial counts using a balanced adder tree
    wire [7:0] level1 [0:15];
    wire [7:0] level2 [0:7];
    wire [7:0] level3 [0:3];
    wire [7:0] level4 [0:1];
    
    // First level of addition (16 adders)
    generate
        for (i = 0; i < 16; i = i + 1) begin : LEVEL1
            assign level1[i] = partial_counts[i*2] + partial_counts[i*2+1];
        end
    endgenerate
    
    // Second level of addition (8 adders)
    generate
        for (i = 0; i < 8; i = i + 1) begin : LEVEL2
            assign level2[i] = level1[i*2] + level1[i*2+1];
        end
    endgenerate
    
    // Third level of addition (4 adders)
    generate
        for (i = 0; i < 4; i = i + 1) begin : LEVEL3
            assign level3[i] = level2[i*2] + level2[i*2+1];
        end
    endgenerate
    
    // Fourth level of addition (2 adders)
    generate
        for (i = 0; i < 2; i = i + 1) begin : LEVEL4
            assign level4[i] = level3[i*2] + level3[i*2+1];
        end
    endgenerate
    
    // Final addition
    assign out = level4[0] + level4[1];

endmodule