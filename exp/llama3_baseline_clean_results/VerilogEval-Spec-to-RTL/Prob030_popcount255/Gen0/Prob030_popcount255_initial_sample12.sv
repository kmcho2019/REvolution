module TopModule(in, out);
    input [254:0] in;
    output [7:0] out;

    // Initialize variables to hold the counts
    wire [7:0] count;

    // First level: count the number of '1's in each 1-bit chunk
    wire [254:0] first_level;
    genvar i;
    generate
        for (i = 0; i < 255; i = i + 1) begin
            assign first_level[i] = in[i];
        end
    endgenerate

    // Second level: count the number of '1's in each 2-bit chunk
    wire [127:0] second_level;
    generate
        for (i = 0; i < 255; i = i + 2) begin
            assign second_level[i/2] = first_level[i] + first_level[i+1];
        end
    endgenerate

    // Third level: count the number of '1's in each 4-bit chunk
    wire [63:0] third_level;
    generate
        for (i = 0; i < 255; i = i + 4) begin
            assign third_level[i/4] = second_level[i/2] + second_level[i/2 + 1];
        end
    endgenerate

    // Fourth level: count the number of '1's in each 8-bit chunk
    wire [31:0] fourth_level;
    generate
        for (i = 0; i < 255; i = i + 8) begin
            if (i + 7 < 255) begin
                assign fourth_level[i/8] = third_level[i/4] + third_level[i/4 + 1];
            end else begin
                assign fourth_level[i/8] = third_level[i/4];
            end
        end
    endgenerate

    // Fifth level: count the number of '1's in each 16-bit chunk
    wire [15:0] fifth_level;
    generate
        for (i = 0; i < 255; i = i + 16) begin
            if (i + 15 < 255) begin
                assign fifth_level[i/16] = fourth_level[i/8] + fourth_level[i/8 + 1];
            end else begin
                assign fifth_level[i/16] = fourth_level[i/8];
            end
        end
    endgenerate

    // Sixth level: count the number of '1's in each 32-bit chunk
    wire [7:0] sixth_level;
    generate
        for (i = 0; i < 255; i = i + 32) begin
            if (i + 31 < 255) begin
                assign sixth_level[i/32] = fifth_level[i/16] + fifth_level[i/16 + 1];
            end else begin
                assign sixth_level[i/32] = fifth_level[i/16];
            end
        end
    endgenerate

    // Seventh level: count the number of '1's in each 64-bit chunk
    wire [3:0] seventh_level;
    assign seventh_level[0] = sixth_level[0] + sixth_level[1];
    assign seventh_level[1] = sixth_level[2] + sixth_level[3];
    assign seventh_level[2] = sixth_level[4] + sixth_level[5];
    assign seventh_level[3] = sixth_level[6] + sixth_level[7];

    // Eighth level: count the number of '1's in each 128-bit chunk
    wire [1:0] eighth_level;
    assign eighth_level[0] = seventh_level[0] + seventh_level[1];
    assign eighth_level[1] = seventh_level[2] + seventh_level[3];

    // Final level: count the total number of '1's
    assign count = eighth_level[0] + eighth_level[1];

    // Output the final count
    assign out = count;
endmodule