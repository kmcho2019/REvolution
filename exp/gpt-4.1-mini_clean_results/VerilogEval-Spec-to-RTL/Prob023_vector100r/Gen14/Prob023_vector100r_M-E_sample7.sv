module TopModule (
    input  [99:0] in,
    output [99:0] out
);
    // Divide input into 10 blocks of 10 bits
    wire [9:0] block_in [9:0];
    wire [9:0] block_out [9:0];

    // Assign input slices to block_in array
    assign block_in[0] = in[  9:  0];
    assign block_in[1] = in[ 19: 10];
    assign block_in[2] = in[ 29: 20];
    assign block_in[3] = in[ 39: 30];
    assign block_in[4] = in[ 49: 40];
    assign block_in[5] = in[ 59: 50];
    assign block_in[6] = in[ 69: 60];
    assign block_in[7] = in[ 79: 70];
    assign block_in[8] = in[ 89: 80];
    assign block_in[9] = in[ 99: 90];

    // Reverse bits inside each 10-bit block
    function [9:0] reverse_10bits;
        input [9:0] val;
        integer i;
        begin
            for (i = 0; i < 10; i = i + 1)
                reverse_10bits[i] = val[9 - i];
        end
    endfunction

    genvar idx;
    generate
        for (idx = 0; idx < 10; idx = idx + 1) begin : bit_reverse_blocks
            assign block_out[idx] = reverse_10bits(block_in[idx]);
        end
    endgenerate

    // Reverse the order of the 10 blocks and concatenate to form output
    assign out = {block_out[0], block_out[1], block_out[2], block_out[3], block_out[4],
                  block_out[5], block_out[6], block_out[7], block_out[8], block_out[9]};

    // But out must have reversed block order
    // So output[99:90] = reversed block_in[0]
    // output[89:80] = reversed block_in[1] and so forth,
    // meaning blocks concatenated in reverse order.

    // Fix concatenation order:
    wire [99:0] out_unordered;
    assign out_unordered = {block_out[9], block_out[8], block_out[7], block_out[6], block_out[5],
                            block_out[4], block_out[3], block_out[2], block_out[1], block_out[0]};

    assign out = out_unordered;

endmodule