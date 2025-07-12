module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Pad input to 256 bits (next power of 2) by adding a zero
    wire [255:0] padded_in = {1'b0, in};

    // Level 1: Count '1's in 8-bit chunks (32 chunks)
    wire [3:0] level1 [0:31];
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : level1_counters
            assign level1[i] = padded_in[i*8]   + padded_in[i*8+1] + 
                             padded_in[i*8+2] + padded_in[i*8+3] + 
                             padded_in[i*8+4] + padded_in[i*8+5] + 
                             padded_in[i*8+6] + padded_in[i*8+7];
        end
    endgenerate

    // Level 2: Sum 2 level1 counters (16 groups)
    wire [4:0] level2 [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : level2_adders
            assign level2[i] = level1[i*2] + level1[i*2+1];
        end
    endgenerate

    // Level 3: Sum 2 level2 counters (8 groups)
    wire [5:0] level3 [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : level3_adders
            assign level3[i] = level2[i*2] + level2[i*2+1];
        end
    endgenerate

    // Level 4: Sum all level3 counters (8 inputs)
    wire [7:0] temp_sum1 = level3[0] + level3[1];
    wire [7:0] temp_sum2 = level3[2] + level3[3];
    wire [7:0] temp_sum3 = level3[4] + level3[5];
    wire [7:0] temp_sum4 = level3[6] + level3[7];
    
    wire [7:0] temp_sum12 = temp_sum1 + temp_sum2;
    wire [7:0] temp_sum34 = temp_sum3 + temp_sum4;
    
    assign out = temp_sum12 + temp_sum34;

endmodule