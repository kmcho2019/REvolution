module TopModule(
    input  [254:0] in,
    output [7:0] out
);

// Divide the input into 255 one-bit chunks
// and count the number of '1's in each chunk
// Since each chunk is only one bit, the count is simply the bit itself

// First, add the counts from each bit in groups of 8 (a byte)
// This results in 32 counts (since 255/8 = 31.875, which we round up to 32, but one is partial)
wire [31:0] byte_counts [7:0];
genvar i;
generate
for (i = 0; i < 32; i = i + 1) begin: byte_adders
    if (i < 31) begin
        assign byte_counts[i] = {in[(i*8)+7], in[(i*8)+6], in[(i*8)+5], in[(i*8)+4], in[(i*8)+3], in[(i*8)+2], in[(i*8)+1], in[(i*8)]};
    end else begin
        // Handle the last, partial byte
        assign byte_counts[i] = {7'b0, in[254], in[253], in[252], in[251], in[250], in[249], in[248]};
    end
end
endgenerate

// Next, add these byte counts in groups of 4 to get 8 counts
wire [7:0] word_counts [3:0];
genvar j;
generate
for (j = 0; j < 8; j = j + 1) begin: word_adders
    if (j < 4) begin
        // For each group of 8 bytes, sum the counts
        assign word_counts[j] = byte_counts[j*2] + byte_counts[j*2 + 1];
    end else begin
        // This isn't used, just to avoid compiler warnings
        assign word_counts[j] = 8'b0;
    end
end
endgenerate

// Finally, add these 4 counts to get the final population count
assign out = word_counts[0] + word_counts[1] + word_counts[2] + word_counts[3];

endmodule