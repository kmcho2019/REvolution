module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Divide the input into 16 chunks of 16 bits
wire [15:0] chunk [15:0];

// Assign the chunks
assign chunk[0] = in[15:0];
assign chunk[1] = in[31:16];
assign chunk[2] = in[47:32];
assign chunk[3] = in[63:48];
assign chunk[4] = in[79:64];
assign chunk[5] = in[95:80];
assign chunk[6] = in[111:96];
assign chunk[7] = in[127:112];
assign chunk[8] = in[143:128];
assign chunk[9] = in[159:144];
assign chunk[10] = in[175:160];
assign chunk[11] = in[191:176];
assign chunk[12] = in[207:192];
assign chunk[13] = in[223:208];
assign chunk[14] = in[239:224];
assign chunk[15] = {1'b0, in[254:240]};

// Lookup table to calculate population count for each chunk
wire [4:0] population_count [15:0];

// Shared lookup table
lookup_table lut(
    .in(chunk[0]),
    .out(population_count[0])
);

// Assign population counts for each chunk
assign population_count[1] = population_count[0];
assign population_count[2] = population_count[0];
assign population_count[3] = population_count[0];
assign population_count[4] = population_count[0];
assign population_count[5] = population_count[0];
assign population_count[6] = population_count[0];
assign population_count[7] = population_count[0];
assign population_count[8] = population_count[0];
assign population_count[9] = population_count[0];
assign population_count[10] = population_count[0];
assign population_count[11] = population_count[0];
assign population_count[12] = population_count[0];
assign population_count[13] = population_count[0];
assign population_count[14] = population_count[0];
assign population_count[15] = population_count[0];

// Pipelined architecture to calculate final population count
wire [7:0] pipeline_out [15:0];

// First stage
assign pipeline_out[0] = population_count[0] + population_count[1];

// Second stage
assign pipeline_out[1] = pipeline_out[0] + population_count[2] + population_count[3];

// Third stage
assign pipeline_out[2] = pipeline_out[1] + population_count[4] + population_count[5];

// Fourth stage
assign pipeline_out[3] = pipeline_out[2] + population_count[6] + population_count[7];

// Fifth stage
assign pipeline_out[4] = pipeline_out[3] + population_count[8] + population_count[9];

// Sixth stage
assign pipeline_out[5] = pipeline_out[4] + population_count[10] + population_count[11];

// Seventh stage
assign pipeline_out[6] = pipeline_out[5] + population_count[12] + population_count[13];

// Eighth stage
assign pipeline_out[7] = pipeline_out[6] + population_count[14] + population_count[15];

// Final output
assign out = pipeline_out[7];

endmodule

module lookup_table(
    input [15:0] in,
    output [4:0] out
);

// Lookup table implementation
reg [4:0] lut [2**16-1:0];

always @(*) begin
    out = lut[in];
end

initial begin
    for (int i = 0; i < 2**16; i++) begin
        lut[i] = $countones(i);
    end
end

endmodule