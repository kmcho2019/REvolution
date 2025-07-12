module TopModule (
    input  [254:0] in,
    output [7:0] out
);

// Divide the input into 16 segments of 16 bits (with the last segment being 15 bits, padded with zeros to make it 16 bits)
wire [15:0] segment [15:0];

// Population count for each segment using a lookup table-based approach
wire [4:0] segment_count [15:0];

// Initialize the lookup table for population count
wire [4:0] population_count_table [15:0];
assign population_count_table[0]  = 5'd0;
assign population_count_table[1]  = 5'd1;
assign population_count_table[2]  = 5'd1;
assign population_count_table[3]  = 5'd2;
assign population_count_table[4]  = 5'd1;
assign population_count_table[5]  = 5'd2;
assign population_count_table[6]  = 5'd2;
assign population_count_table[7]  = 5'd3;
assign population_count_table[8]  = 5'd1;
assign population_count_table[9]  = 5'd2;
assign population_count_table[10] = 5'd2;
assign population_count_table[11] = 5'd3;
assign population_count_table[12] = 5'd2;
assign population_count_table[13] = 5'd3;
assign population_count_table[14] = 5'd3;
assign population_count_table[15] = 5'd4;

// Generate the population count for each segment using the lookup table
genvar i;
generate
    for (i = 0; i < 16; i++) begin
        assign segment[i] = in[(i*16)+:16];
        assign segment_count[i] = population_count_table[segment[i][0]] + population_count_table[segment[i][1]] + population_count_table[segment[i][2]] + population_count_table[segment[i][3]] + population_count_table[segment[i][4]] + population_count_table[segment[i][5]] + population_count_table[segment[i][6]] + population_count_table[segment[i][7]] + population_count_table[segment[i][8]] + population_count_table[segment[i][9]] + population_count_table[segment[i][10]] + population_count_table[segment[i][11]] + population_count_table[segment[i][12]] + population_count_table[segment[i][13]] + population_count_table[segment[i][14]] + population_count_table[segment[i][15]];
    end
endgenerate

// Parallel adder to sum up the counts from each segment
reg [7:0] count;
always @(*) begin
    count = 8'd0;
    for (int i = 0; i < 16; i++) begin
        count = count + segment_count[i];
    end
end

assign out = count;

endmodule