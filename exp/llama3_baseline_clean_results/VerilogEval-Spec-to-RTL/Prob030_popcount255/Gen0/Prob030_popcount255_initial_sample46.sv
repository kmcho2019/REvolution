module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Level 1: Count '1's in 16-bit chunks
wire [15:0] count1 [15:0];
genvar i;
generate
    for (i = 0; i < 16; i = i + 1) begin
        // Count '1's in a 16-bit chunk
        assign count1[i] = {1'b0, in[(i * 16 + 15) : (i * 16)]} + 1'b0;
    end
endgenerate

// Level 2: Add counts from each 16-bit chunk
wire [7:0] count2 [7:0];
generate
    for (i = 0; i < 8; i = i + 1) begin
        // Add counts from two 16-bit chunks
        assign count2[i] = count1[i * 2] + count1[i * 2 + 1];
    end
endgenerate

// Level 3: Add counts from each pair of 16-bit chunks
wire [7:0] count3 [3:0];
generate
    for (i = 0; i < 4; i = i + 1) begin
        // Add counts from two pairs of 16-bit chunks
        assign count3[i] = count2[i * 2] + count2[i * 2 + 1];
    end
endgenerate

// Level 4: Add counts from each group of 4 pairs of 16-bit chunks
wire [7:0] count4 [1:0];
generate
    for (i = 0; i < 2; i = i + 1) begin
        // Add counts from two groups of 4 pairs of 16-bit chunks
        assign count4[i] = count3[i * 2] + count3[i * 2 + 1];
    end
endgenerate

// Final count
assign out = count4[0] + count4[1];

endmodule