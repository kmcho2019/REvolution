module TopModule(
    input  [254:0] in,
    output [7:0] out
);

    wire [7:0] count;

    // Level 1: Count '1's in each group of 2 bits
    wire [127:0] count2;
    genvar i;
    generate
        for (i = 0; i < 128; i++) begin
            assign count2[i] = in[2*i] + in[2*i+1];
        end
    endgenerate

    // Level 2: Count '1's in each group of 4 bits
    wire [63:0] count4;
    generate
        for (i = 0; i < 64; i++) begin
            assign count4[i] = count2[2*i] + count2[2*i+1];
        end
    endgenerate

    // Level 3: Count '1's in each group of 8 bits
    wire [31:0] count8;
    generate
        for (i = 0; i < 32; i++) begin
            assign count8[i] = count4[2*i] + count4[2*i+1];
        end
    endgenerate

    // Level 4: Count '1's in each group of 16 bits
    wire [15:0] count16;
    generate
        for (i = 0; i < 16; i++) begin
            assign count16[i] = count8[2*i] + count8[2*i+1];
        end
    endgenerate

    // Level 5: Count '1's in each group of 32 bits
    wire [7:0] count32;
    generate
        for (i = 0; i < 8; i++) begin
            assign count32[i] = count16[2*i] + count16[2*i+1];
        end
    endgenerate

    // Final addition
    assign count = count32[0] + count32[1] + count32[2] + count32[3] + count32[4] + count32[5] + count32[6] + count32[7];

    // Output
    assign out = count;

endmodule