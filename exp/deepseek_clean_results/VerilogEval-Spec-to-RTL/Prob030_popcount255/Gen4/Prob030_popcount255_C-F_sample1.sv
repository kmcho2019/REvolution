module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // First level: Count '1's in each 5-bit chunk (51 chunks)
    wire [4:0] chunk_counts [0:50];
    genvar i;
    generate
        for (i = 0; i < 51; i = i + 1) begin : count_chunks
            if (i < 50) begin : normal_chunks
                assign chunk_counts[i] = 
                    in[i*5 + 0] + in[i*5 + 1] + 
                    in[i*5 + 2] + in[i*5 + 3] + 
                    in[i*5 + 4];
            end
            else begin : last_chunk  // Last chunk has only 5 bits (255 = 51*5)
                assign chunk_counts[i] = 
                    in[i*5 + 0] + in[i*5 + 1] + 
                    in[i*5 + 2] + in[i*5 + 3] + 
                    in[i*5 + 4];
            end
        end
    endgenerate

    // Second level: Sum groups of 3 chunks (17 groups)
    wire [6:0] level1 [0:16];
    generate
        for (i = 0; i < 17; i = i + 1) begin : sum_level1
            if (i < 16) begin : normal_groups
                assign level1[i] = chunk_counts[i*3] + chunk_counts[i*3 + 1] + chunk_counts[i*3 + 2];
            end
            else begin : last_group  // Last group has only 3 chunks (51 = 17*3)
                assign level1[i] = chunk_counts[i*3] + chunk_counts[i*3 + 1] + chunk_counts[i*3 + 2];
            end
        end
    endgenerate

    // Third level: Sum all level1 results (17 inputs)
    reg [7:0] final_sum;
    integer j;
    always @(*) begin
        final_sum = 0;
        for (j = 0; j < 17; j = j + 1) begin
            final_sum = final_sum + level1[j];
        end
    end

    assign out = final_sum;

endmodule