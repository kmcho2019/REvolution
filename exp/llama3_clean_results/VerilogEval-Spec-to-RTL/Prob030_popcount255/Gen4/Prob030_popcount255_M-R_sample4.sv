// Module to calculate population count for an 8-bit chunk
module PopulationCountChunk(
    input  [7:0] in,
    output [3:0] out
);
    assign out = {
        in[7] + in[6] + in[5] + in[4] +
        in[3] + in[2] + in[1] + in[0]
    };
endmodule

// Top module to divide the 255-bit input into chunks and sum the population counts
module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    wire [3:0] chunk_count [31:0];
    reg [7:0] count;

    // Divide the input into chunks and calculate population count for each chunk
    genvar i;
    generate
        for (i = 0; i < 32; i++) begin
            if (i < 31) begin
                PopulationCountChunk chunk_i(
                    .in(in[(i*8)+:8]),
                    .out(chunk_count[i])
                );
            end else begin
                PopulationCountChunk chunk_i(
                    .in({1'b0, in[(i*8)+:7]}),
                    .out(chunk_count[i])
                );
            end
        end
    endgenerate

    // Sum the population counts from each chunk
    assign count = chunk_count[0] + chunk_count[1] + chunk_count[2] + chunk_count[3] +
                   chunk_count[4] + chunk_count[5] + chunk_count[6] + chunk_count[7] +
                   chunk_count[8] + chunk_count[9] + chunk_count[10] + chunk_count[11] +
                   chunk_count[12] + chunk_count[13] + chunk_count[14] + chunk_count[15] +
                   chunk_count[16] + chunk_count[17] + chunk_count[18] + chunk_count[19] +
                   chunk_count[20] + chunk_count[21] + chunk_count[22] + chunk_count[23] +
                   chunk_count[24] + chunk_count[25] + chunk_count[26] + chunk_count[27] +
                   chunk_count[28] + chunk_count[29] + chunk_count[30] + chunk_count[31];

    assign out = count;
endmodule