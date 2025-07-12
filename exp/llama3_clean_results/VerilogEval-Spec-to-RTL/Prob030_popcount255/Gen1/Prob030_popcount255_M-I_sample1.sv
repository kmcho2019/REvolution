module TopModule(
    input  [255:0] in,
    output [7:0] out
);

    wire [7:0] byte_counts [31:0];

    // Count the number of '1's in each byte
    for (genvar i = 0; i < 32; i++) begin
        wire [7:0] count;
        reg [7:0] temp_count;
        integer j;

        always @(*) begin
            temp_count = 8'd0;
            for (j = 0; j < 8; j++) begin
                if (in[8*i + j]) begin
                    temp_count = temp_count + 1'd1;
                end
            end
            count = temp_count;
        end

        assign byte_counts[i] = count;
    end

    // Sum up the counts from each byte in a hierarchical manner
    wire [7:0] level1_adders [15:0];
    wire [8:0] level2_adders [7:0];
    wire [9:0] level3_adders [3:0];
    wire [10:0] level4_adders [1:0];

    // Level 1: Add pairs of bytes
    for (genvar i = 0; i < 16; i++) begin
        assign level1_adders[i] = byte_counts[2*i] + byte_counts[2*i+1];
    end

    // Level 2: Add pairs of level 1 results
    for (genvar i = 0; i < 8; i++) begin
        assign level2_adders[i] = level1_adders[2*i] + level1_adders[2*i+1];
    end

    // Level 3: Add pairs of level 2 results
    for (genvar i = 0; i < 4; i++) begin
        assign level3_adders[i] = level2_adders[2*i] + level2_adders[2*i+1];
    end

    // Level 4: Add pairs of level 3 results
    for (genvar i = 0; i < 2; i++) begin
        assign level4_adders[i] = level3_adders[2*i] + level3_adders[2*i+1];
    end

    // Final addition
    assign out = level4_adders[0][7:0] + level4_adders[1][7:0];

endmodule