module TopModule(in, out);
    input [255:0] in;
    output [7:0] out;

    // Level 1: 1-bit counters
    wire [127:0] count1;

    // Initialize count1
    genvar i;
    generate
        for (i = 0; i < 128; i++) begin
            assign count1[i] = in[i*2] + in[i*2 + 1];
        end
    endgenerate

    // Level 2: 2-bit counters
    wire [63:0] count2;

    // Initialize count2
    generate
        for (i = 0; i < 64; i++) begin
            assign count2[i] = count1[i*2] + count1[i*2 + 1];
        end
    endgenerate

    // Level 3: 4-bit counters
    wire [31:0] count3;

    // Initialize count3
    generate
        for (i = 0; i < 32; i++) begin
            assign count3[i] = count2[i*2] + count2[i*2 + 1];
        end
    endgenerate

    // Level 4: 8-bit counters
    wire [15:0] count4;

    // Initialize count4
    generate
        for (i = 0; i < 16; i++) begin
            assign count4[i] = count3[i*2] + count3[i*2 + 1];
        end
    endgenerate

    // Level 5: 16-bit counters
    wire [7:0] count5;

    // Initialize count5
    generate
        for (i = 0; i < 8; i++) begin
            assign count5[i] = count4[i*2] + count4[i*2 + 1];
        end
    endgenerate

    // Final output
    assign out = count5[0] + count5[1] + count5[2] + count5[3] + count5[4] + count5[5] + count5[6] + count5[7];
endmodule