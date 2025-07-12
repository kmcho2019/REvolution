module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // First level: Sum bits in groups of 4 (64 groups)
    wire [2:0] level1 [0:63];
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : LEVEL1
            localparam start = i*4;
            localparam end_bit = (start+3 > 254) ? 254 : start+3;
            localparam num_bits = end_bit - start + 1;
            
            case (num_bits)
                4: assign level1[i] = in[start] + in[start+1] + in[start+2] + in[start+3];
                3: assign level1[i] = in[start] + in[start+1] + in[start+2];
                2: assign level1[i] = in[start] + in[start+1];
                1: assign level1[i] = in[start];
            endcase
        end
    endgenerate

    // Second level: Sum level1 results in groups of 4 (16 groups)
    wire [4:0] level2 [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : LEVEL2
            localparam start = i*4;
            localparam end_group = (start+3 > 63) ? 63 : start+3;
            localparam num_groups = end_group - start + 1;
            
            case (num_groups)
                4: assign level2[i] = level1[start] + level1[start+1] + level1[start+2] + level1[start+3];
                3: assign level2[i] = level1[start] + level1[start+1] + level1[start+2];
                2: assign level2[i] = level1[start] + level1[start+1];
                1: assign level2[i] = level1[start];
            endcase
        end
    endgenerate

    // Third level: Sum level2 results in groups of 4 (4 groups)
    wire [6:0] level3 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : LEVEL3
            localparam start = i*4;
            localparam end_group = (start+3 > 15) ? 15 : start+3;
            localparam num_groups = end_group - start + 1;
            
            case (num_groups)
                4: assign level3[i] = level2[start] + level2[start+1] + level2[start+2] + level2[start+3];
                3: assign level3[i] = level2[start] + level2[start+1] + level2[start+2];
                2: assign level3[i] = level2[start] + level2[start+1];
                1: assign level3[i] = level2[start];
            endcase
        end
    endgenerate

    // Final balanced binary tree summation
    wire [7:0] sum01 = level3[0] + level3[1];
    wire [7:0] sum23 = level3[2] + level3[3];
    assign out = sum01 + sum23;

endmodule