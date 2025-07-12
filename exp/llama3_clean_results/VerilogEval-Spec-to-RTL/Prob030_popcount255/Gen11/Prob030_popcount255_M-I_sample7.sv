module TopModule(
    input [254:0] in,
    output [7:0] out
);

    wire [4:0] segment_counts [14:0];

    // Count '1's in each 17-bit segment
    genvar i;
    generate
        for (i = 0; i < 15; i++) begin
            reg [4:0] segment_count;
            always @(in) begin
                segment_count = 5'b0;
                for (int j = 0; j < 17; j++) begin
                    segment_count = segment_count + in[i*17 + j];
                end
            end
            assign segment_counts[i] = segment_count;
        end
    endgenerate

    // Combine segment counts using a tree-like structure
    wire [7:0] level1_counts [7:0];
    genvar k;
    generate
        for (k = 0; k < 8; k++) begin
            assign level1_counts[k] = segment_counts[k*2] + segment_counts[k*2 + 1];
        end
    endgenerate

    wire [7:0] level2_counts [3:0];
    genvar l;
    generate
        for (l = 0; l < 4; l++) begin
            assign level2_counts[l] = level1_counts[l*2] + level1_counts[l*2 + 1];
        end
    endgenerate

    wire [7:0] level3_counts [1:0];
    genvar m;
    generate
        for (m = 0; m < 2; m++) begin
            assign level3_counts[m] = level2_counts[m*2] + level2_counts[m*2 + 1];
        end
    endgenerate

    assign out = level3_counts[0] + level3_counts[1];

endmodule