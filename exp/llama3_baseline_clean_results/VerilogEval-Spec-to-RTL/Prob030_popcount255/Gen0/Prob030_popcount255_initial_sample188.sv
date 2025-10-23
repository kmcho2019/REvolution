module TopModule(
    input  [254:0] in,
    output [7:0] out
);

// Counting the number of '1's in groups of 1, 2, 4, 8, 16, 32, 64, and 128 bits
// Level 0: Counting 1's in groups of 1 bit
wire [254:0] count_level_0;
assign count_level_0 = in;

// Level 1: Counting 1's in groups of 2 bits
wire [127:0] count_level_1;
genvar i;
generate
for(i = 0; i < 128; i++) begin
    assign count_level_1[i] = count_level_0[2*i] + count_level_0[2*i + 1];
end
endgenerate

// Level 2: Counting 1's in groups of 4 bits
wire [63:0] count_level_2;
generate
for(i = 0; i < 64; i++) begin
    assign count_level_2[i] = count_level_1[2*i] + count_level_1[2*i + 1];
end
endgenerate

// Level 3: Counting 1's in groups of 8 bits
wire [31:0] count_level_3;
generate
for(i = 0; i < 32; i++) begin
    assign count_level_3[i] = count_level_2[2*i] + count_level_2[2*i + 1];
end
endgenerate

// Level 4: Counting 1's in groups of 16 bits
wire [15:0] count_level_4;
generate
for(i = 0; i < 16; i++) begin
    assign count_level_4[i] = count_level_3[2*i] + count_level_3[2*i + 1];
end
endgenerate

// Level 5: Counting 1's in groups of 32 bits
wire [7:0] count_level_5;
generate
for(i = 0; i < 8; i++) begin
    assign count_level_5[i] = count_level_4[2*i] + count_level_4[2*i + 1];
end
endgenerate

// Level 6: Counting 1's in groups of 64 bits
wire [3:0] count_level_6;
generate
for(i = 0; i < 4; i++) begin
    assign count_level_6[i] = count_level_5[2*i] + count_level_5[2*i + 1];
end
endgenerate

// Level 7: Counting 1's in groups of 128 bits
wire [1:0] count_level_7;
generate
for(i = 0; i < 2; i++) begin
    assign count_level_7[i] = count_level_6[2*i] + count_level_6[2*i + 1];
end
endgenerate

// Level 8: Final addition
assign out = count_level_7[0] + count_level_7[1];

endmodule