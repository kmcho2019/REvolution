module TopModule(
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);
    // Step 1: Split input into 256 words of 4 bits
    wire [3:0] words [0:255];
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin
            assign words[i] = in[4*i +: 4];
        end
    endgenerate

    // Step 2: Create mux tree levels:
    // Level 0 has 256 inputs,
    // Level 1 has 128,
    // ...
    // Level 8 has 1 output (out)

    // Define arrays for each level of mux outputs
    // level_mux[n][k] is the output of the k-th mux at level n
    // level 0 is the original inputs (words)
    
    // To keep code concise, define an array of arrays for each level using generate
    // Level 0 wires are words themselves, no new wires needed

    // We'll use a 2D wire array for each level's mux outputs
    // Level 0: 256 wires
    // Level 1: 128 wires
    // Level 2: 64 wires
    // Level 3: 32 wires
    // Level 4: 16 wires
    // Level 5: 8 wires
    // Level 6: 4 wires
    // Level 7: 2 wires
    // Level 8: 1 wire (out)

    // Declare intermediate level wires
    wire [3:0] level1 [0:127];
    wire [3:0] level2 [0:63];
    wire [3:0] level3 [0:31];
    wire [3:0] level4 [0:15];
    wire [3:0] level5 [0:7];
    wire [3:0] level6 [0:3];
    wire [3:0] level7 [0:1];
    wire [3:0] level8;

    // Level 1 mux: select between words[2*k] and words[2*k+1] based on sel[0]
    generate
        for (i = 0; i < 128; i = i + 1) begin
            assign level1[i] = sel[0] ? words[2*i+1] : words[2*i];
        end
    endgenerate

    // Level 2 mux: select between level1[2*k] and level1[2*k+1] based on sel[1]
    generate
        for (i = 0; i < 64; i = i + 1) begin
            assign level2[i] = sel[1] ? level1[2*i+1] : level1[2*i];
        end
    endgenerate

    // Level 3 mux: select between level2[2*k] and level2[2*k+1] based on sel[2]
    generate
        for (i = 0; i < 32; i = i + 1) begin
            assign level3[i] = sel[2] ? level2[2*i+1] : level2[2*i];
        end
    endgenerate

    // Level 4 mux: select between level3[2*k] and level3[2*k+1] based on sel[3]
    generate
        for (i = 0; i < 16; i = i + 1) begin
            assign level4[i] = sel[3] ? level3[2*i+1] : level3[2*i];
        end
    endgenerate

    // Level 5 mux: select between level4[2*k] and level4[2*k+1] based on sel[4]
    generate
        for (i = 0; i < 8; i = i + 1) begin
            assign level5[i] = sel[4] ? level4[2*i+1] : level4[2*i];
        end
    endgenerate

    // Level 6 mux: select between level5[2*k] and level5[2*k+1] based on sel[5]
    generate
        for (i = 0; i < 4; i = i + 1) begin
            assign level6[i] = sel[5] ? level5[2*i+1] : level5[2*i];
        end
    endgenerate

    // Level 7 mux: select between level6[0] and level6[1] at sel[6]
    assign level7[0] = sel[6] ? level6[1] : level6[0];
    assign level7[1] = sel[6] ? level6[3] : level6[2];

    // Level 8 mux: select between level7[0] and level7[1] at sel[7]
    assign level8 = sel[7] ? level7[1] : level7[0];

    assign out = level8;

endmodule