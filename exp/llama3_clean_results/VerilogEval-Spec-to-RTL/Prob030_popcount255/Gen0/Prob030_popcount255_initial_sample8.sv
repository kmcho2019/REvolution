module TopModule(
    input  [255:0] in,
    output [7:0] out
);

// Count the number of '1's in a 255-bit vector
wire [7:0] count;

// Implementing a population count using a tree-like structure
// First level: Count '1's in groups of 2
wire [127:0] group2_count;
genvar i;
generate
    for (i = 0; i < 128; i++) begin
        assign group2_count[i] = in[2*i] + in[2*i+1];
    end
endgenerate

// Second level: Count '1's in groups of 4
wire [63:0] group4_count;
generate
    for (i = 0; i < 64; i++) begin
        assign group4_count[i] = group2_count[2*i] + group2_count[2*i+1];
    end
endgenerate

// Third level: Count '1's in groups of 8
wire [31:0] group8_count;
generate
    for (i = 0; i < 32; i++) begin
        assign group8_count[i] = group4_count[2*i] + group4_count[2*i+1];
    end
endgenerate

// Fourth level: Count '1's in groups of 16
wire [15:0] group16_count;
generate
    for (i = 0; i < 16; i++) begin
        assign group16_count[i] = group8_count[2*i] + group8_count[2*i+1];
    end
endgenerate

// Fifth level: Count '1's in groups of 32
wire [7:0] group32_count;
generate
    for (i = 0; i < 8; i++) begin
        assign group32_count[i] = group16_count[2*i] + group16_count[2*i+1];
    end
endgenerate

// Final level: Sum up counts from groups of 32
assign count = group32_count[0] + group32_count[1] + group32_count[2] + group32_count[3] +
               group32_count[4] + group32_count[5] + group32_count[6] + group32_count[7];

assign out = count;

endmodule