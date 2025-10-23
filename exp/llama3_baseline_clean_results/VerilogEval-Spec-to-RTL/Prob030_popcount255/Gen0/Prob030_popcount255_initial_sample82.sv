module TopModule(
    input  [254:0] in,
    output [7:0] out
);

// Level 1: Count '1's in groups of 2
wire [127:0] count_2;

genvar i;
generate
    for (i = 0; i < 128; i = i + 1) begin
        assign count_2[i] = in[2*i] + in[2*i+1];
    end
endgenerate

// Level 2: Count '1's in groups of 4
wire [63:0] count_4;

generate
    for (i = 0; i < 64; i = i + 1) begin
        assign count_4[i] = count_2[2*i] + count_2[2*i+1];
    end
endgenerate

// Level 3: Count '1's in groups of 8
wire [31:0] count_8;

generate
    for (i = 0; i < 32; i = i + 1) begin
        assign count_8[i] = count_4[2*i] + count_4[2*i+1];
    end
endgenerate

// Level 4: Count '1's in groups of 16
wire [15:0] count_16;

generate
    for (i = 0; i < 16; i = i + 1) begin
        assign count_16[i] = count_8[2*i] + count_8[2*i+1];
    end
endgenerate

// Level 5: Count '1's in groups of 32
wire [7:0] count_32;

generate
    for (i = 0; i < 8; i = i + 1) begin
        assign count_32[i] = count_16[2*i] + count_16[2*i+1];
    end
endgenerate

// Level 6: Count '1's in groups of 64
wire [3:0] count_64;

generate
    for (i = 0; i < 4; i = i + 1) begin
        assign count_64[i] = count_32[2*i] + count_32[2*i+1];
    end
endgenerate

// Level 7: Count '1's in groups of 128
wire [1:0] count_128;

generate
    for (i = 0; i < 2; i = i + 1) begin
        assign count_128[i] = count_64[2*i] + count_64[2*i+1];
    end
endgenerate

// Final addition
assign out[0] = count_128[0] & 1;
assign out[1] = (count_128[0] >> 1) + (count_128[1] & 1);
assign out[2] = (count_128[1] >> 1);

// Since we are adding 2-bit numbers in the last step, we need to propagate the carry
// from the addition of the two most significant bits of the counts
assign out[3] = (count_128[1] >> 1) + (out[2] >> 1);
assign out[4] = (out[3] >> 1);
assign out[5] = (out[4] >> 1);
assign out[6] = (out[5] >> 1);
assign out[7] = (out[6] >> 1);

endmodule