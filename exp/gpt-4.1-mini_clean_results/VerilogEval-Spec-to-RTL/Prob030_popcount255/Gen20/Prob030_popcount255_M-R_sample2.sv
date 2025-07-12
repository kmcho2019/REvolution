`timescale 1ns/1ps

module TopModule (
    input  wire [254:0] in,
    output wire [7:0] out
);
    // Parameterized flat popcount function to count bits of any input vector
    // Uses generate-for to iteratively sum bits pairwise and reduce width

    function automatic [31:0] popcount;
        input integer width;
        input wire [width-1:0] data;
        integer stage_width;
        integer i, j;
        reg [width-1:0] current_stage;
        reg [width-1:0] next_stage;
        begin
            current_stage = data;
            stage_width = width;

            // Iteratively sum pairs of bits until only one value remains
            while (stage_width > 1) begin
                for (i=0, j=0; i < stage_width; i = i + 2, j = j + 1) begin
                    if (i+1 < stage_width)
                        next_stage[j] = current_stage[i] + current_stage[i+1];
                    else
                        next_stage[j] = current_stage[i];
                end
                current_stage = next_stage;
                stage_width = (stage_width + 1) >> 1;
            end
            popcount = current_stage[0];
        end
    endfunction

    // Use generate to create partial counts for 5 chunks of 51 bits each
    localparam CHUNK_SIZE = 51;
    localparam NUM_CHUNKS = 5;

    wire [5:0] partial_counts [NUM_CHUNKS-1:0]; // 6 bits to count up to 51

    genvar idx;
    generate
        for (idx = 0; idx < NUM_CHUNKS; idx = idx + 1) begin : gen_partial_counts
            assign partial_counts[idx] = popcount(CHUNK_SIZE, in[idx*CHUNK_SIZE +: CHUNK_SIZE]);
        end
    endgenerate

    // Sum the 5 partial counts to get the final population count
    // Max sum is 255 (8 bits)
    wire [7:0] sum01 = partial_counts[0] + partial_counts[1];
    wire [7:0] sum23 = partial_counts[2] + partial_counts[3];
    wire [7:0] sum0123 = sum01 + sum23;
    wire [7:0] sum_final = sum0123 + {2'b00, partial_counts[4]}; // zero extend partial_counts[4]

    assign out = sum_final;

endmodule