module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

// Pad input to 256 bits (32 groups of 8 bits) by adding a zero
wire [255:0] padded_in = {1'b0, in};

// Count '1's in each 8-bit group using reduction operators
wire [7:0] count_groups [31:0];
genvar i;
generate
    for (i = 0; i < 32; i = i + 1) begin : GROUP_COUNTS
        assign count_groups[i] = $countones(padded_in[i*8 +: 8]);
    end
endgenerate

// First level of adder tree: sum pairs of 8-bit counts -> 9-bit results
wire [8:0] sum_level1 [15:0];
generate
    for (i = 0; i < 16; i = i + 1) begin : LEVEL1_ADDS
        assign sum_level1[i] = count_groups[2*i] + count_groups[2*i+1];
    end
endgenerate

// Second level: sum pairs of 9-bit sums -> 10-bit results
wire [9:0] sum_level2 [7:0];
generate
    for (i = 0; i < 8; i = i + 1) begin : LEVEL2_ADDS
        assign sum_level2[i] = sum_level1[2*i] + sum_level1[2*i+1];
    end
endgenerate

// Third level: sum pairs of 10-bit sums -> 11-bit results
wire [10:0] sum_level3 [3:0];
generate
    for (i = 0; i < 4; i = i + 1) begin : LEVEL3_ADDS
        assign sum_level3[i] = sum_level2[2*i] + sum_level2[2*i+1];
    end
endgenerate

// Fourth level: sum pairs of 11-bit sums -> 12-bit results
wire [11:0] sum_level4 [1:0];
generate
    for (i = 0; i < 2; i = i + 1) begin : LEVEL4_ADDS
        assign sum_level4[i] = sum_level3[2*i] + sum_level3[2*i+1];
    end
endgenerate

// Fifth level: sum the two 12-bit sums -> 13-bit result
wire [12:0] sum_level5 = sum_level4[0] + sum_level4[1];

// Final output is the 8 LSBs (maximum possible value is 255)
assign out = sum_level5[7:0];

endmodule