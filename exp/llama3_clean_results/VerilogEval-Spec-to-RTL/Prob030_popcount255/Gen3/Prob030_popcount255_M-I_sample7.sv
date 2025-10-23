module TopModule (
    input  [254:0] in,
    output [7:0] out
);

// Divide the input into 16 chunks of 16 bits (with the last chunk being 7 bits, padded with zeros to make it 16 bits)
wire [15:0] chunk [15:0];

// Population count for each chunk
wire [4:0] chunk_count [15:0];

// Tree adder to sum up the counts from each chunk
wire [4:0] adder_out [3:0];
wire [7:0] count;

// Generate chunks
genvar i;
generate
    for (i = 0; i < 16; i++) begin
        assign chunk[i] = in[(i*16)+:16];
    end
endgenerate

// Population count for each chunk
genvar j;
generate
    for (i = 0; i < 16; i++) begin
        reg [4:0] count_reg;
        always @(*) begin
            count_reg = 5'd0;
            for (j = 0; j < 16; j++) begin
                if (chunk[i][j]) begin
                    count_reg = count_reg + 1;
                end
            end
            chunk_count[i] = count_reg;
        end
    end
endgenerate

// Tree adder to sum up the counts from each chunk
assign adder_out[0] = chunk_count[0] + chunk_count[1];
assign adder_out[1] = chunk_count[2] + chunk_count[3];
assign adder_out[2] = chunk_count[4] + chunk_count[5];
assign adder_out[3] = chunk_count[6] + chunk_count[7];
assign count = adder_out[0] + adder_out[1] + adder_out[2] + adder_out[3] + 
               chunk_count[8] + chunk_count[9] + chunk_count[10] + chunk_count[11] + 
               chunk_count[12] + chunk_count[13] + chunk_count[14] + chunk_count[15];

assign out = count[7:0];

endmodule