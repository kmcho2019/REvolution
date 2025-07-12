module TopModule #(
    parameter BLOCK_SIZE = 10
) (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    localparam NUM_BLOCKS = 100/BLOCK_SIZE;
    genvar i, j;

    generate
        for (i = 0; i < NUM_BLOCKS; i = i + 1) begin: block
            for (j = 0; j < BLOCK_SIZE; j = j + 1) begin: bit
                localparam bit_idx = i*BLOCK_SIZE + j;
                
                // out_both: AND with left neighbor (MSB of block = 0)
                assign out_both[bit_idx] = (j == BLOCK_SIZE-1) ? 1'b0 : 
                                          in[bit_idx] & in[bit_idx+1];
                
                // out_any: OR with right neighbor (LSB of block = 0)
                assign out_any[bit_idx] = (j == 0) ? 1'b0 :
                                         in[bit_idx] | in[bit_idx-1];
                
                // out_different: XOR with left neighbor (wrapped)
                localparam left_idx = (bit_idx == 0) ? 99 : bit_idx - 1;
                assign out_different[bit_idx] = in[bit_idx] ^ in[left_idx];
            end
        end
    endgenerate

endmodule