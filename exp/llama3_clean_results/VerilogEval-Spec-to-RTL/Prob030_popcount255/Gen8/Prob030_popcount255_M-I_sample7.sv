module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Divide the input into 32 chunks of 8 bits
wire [7:0] chunk [31:0];

// Use $countones function for each chunk
wire [3:0] chunk_count [31:0];

genvar i;
generate
    for (i = 0; i < 32; i++) begin
        assign chunk[i] = in[(i*8)+:8];
        assign chunk_count[i] = $countones(chunk[i]);
    end
endgenerate

// Hierarchical approach to sum up the counts from each chunk
wire [7:0] count;
wire [4:0] count0, count1, count2, count3, count4, count5, count6, count7;
wire [4:0] count10, count11, count12, count13, count14, count15;

assign count0 = chunk_count[0] + chunk_count[1];
assign count1 = chunk_count[2] + chunk_count[3];
assign count2 = chunk_count[4] + chunk_count[5];
assign count3 = chunk_count[6] + chunk_count[7];
assign count4 = chunk_count[8] + chunk_count[9];
assign count5 = chunk_count[10] + chunk_count[11];
assign count6 = chunk_count[12] + chunk_count[13];
assign count7 = chunk_count[14] + chunk_count[15];

assign count10 = count0 + count1;
assign count11 = count2 + count3;
assign count12 = count4 + count5;
assign count13 = count6 + count7;

assign count14 = count10 + count11;
assign count15 = count12 + count13;

assign count = count14 + count15;

assign out = count;

endmodule