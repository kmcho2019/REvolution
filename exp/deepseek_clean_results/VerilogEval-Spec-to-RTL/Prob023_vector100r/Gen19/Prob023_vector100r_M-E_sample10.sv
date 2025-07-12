module TopModule (
    input  [99:0] in,
    output [99:0] out
);

// First reverse the order of 10-bit blocks
wire [99:0] block_reversed;
genvar i;
generate
    for (i = 0; i < 10; i = i + 1) begin : reverse_blocks
        assign block_reversed[i*10 +: 10] = in[(9-i)*10 +: 10];
    end
endgenerate

// Then reverse bits within each 10-bit block
genvar j, k;
generate
    for (j = 0; j < 10; j = j + 1) begin : reverse_bits_in_block
        for (k = 0; k < 10; k = k + 1) begin : bit_reversal
            assign out[j*10 + k] = block_reversed[j*10 + (9 - k)];
        end
    end
endgenerate

endmodule