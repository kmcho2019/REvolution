module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    // Pack inputs into a vector for easier indexing
    wire [4:0] invec = {a, b, c, d, e};

    // Declare wires for unique pairs (i <= j)
    wire [14:0] uniq_cmp; // 5*(5+1)/2 = 15 unique pairs

    // Map indices of unique pairs:
    // pairs in order: (0,0),(0,1),(0,2),(0,3),(0,4),
    //                 (1,1),(1,2),(1,3),(1,4),
    //                 (2,2),(2,3),(2,4),
    //                 (3,3),(3,4),
    //                 (4,4)
    assign uniq_cmp[0]  = ~(invec[0] ^ invec[0]); // a,a
    assign uniq_cmp[1]  = ~(invec[0] ^ invec[1]); // a,b
    assign uniq_cmp[2]  = ~(invec[0] ^ invec[2]); // a,c
    assign uniq_cmp[3]  = ~(invec[0] ^ invec[3]); // a,d
    assign uniq_cmp[4]  = ~(invec[0] ^ invec[4]); // a,e

    assign uniq_cmp[5]  = ~(invec[1] ^ invec[1]); // b,b
    assign uniq_cmp[6]  = ~(invec[1] ^ invec[2]); // b,c
    assign uniq_cmp[7]  = ~(invec[1] ^ invec[3]); // b,d
    assign uniq_cmp[8]  = ~(invec[1] ^ invec[4]); // b,e

    assign uniq_cmp[9]  = ~(invec[2] ^ invec[2]); // c,c
    assign uniq_cmp[10] = ~(invec[2] ^ invec[3]); // c,d
    assign uniq_cmp[11] = ~(invec[2] ^ invec[4]); // c,e

    assign uniq_cmp[12] = ~(invec[3] ^ invec[3]); // d,d
    assign uniq_cmp[13] = ~(invec[3] ^ invec[4]); // d,e

    assign uniq_cmp[14] = ~(invec[4] ^ invec[4]); // e,e

    // Helper function: map (i,j) to unique_cmp index for i <= j
    function [3:0] idx_uniq;
        input integer i, j;
        integer base;
        begin
            if (i > j) begin
                // swap to ensure i <= j
                idx_uniq = idx_uniq(j, i);
            end else begin
                // base = sum_{k=0}^{i-1} (5 - k) = 5*i - i*(i-1)/2
                base = 5 * i - (i * (i - 1)) / 2;
                idx_uniq = base + (j - i);
            end
        end
    endfunction

    // Now assign out bits as out[bit_index] = uniq_cmp[idx_uniq(row, col)] with row,col per output index
    // Output order is out[24:0] mapping:
    // out[24] = ~a ^ a    -> (0,0)
    // out[23] = ~a ^ b    -> (0,1)
    // out[22] = ~a ^ c    -> (0,2)
    // out[21] = ~a ^ d    -> (0,3)
    // out[20] = ~a ^ e    -> (0,4)
    // out[19] = ~b ^ a    -> (1,0)
    // out[18] = ~b ^ b    -> (1,1)
    // out[17] = ~b ^ c    -> (1,2)
    // out[16] = ~b ^ d    -> (1,3)
    // out[15] = ~b ^ e    -> (1,4)
    // out[14] = ~c ^ a    -> (2,0)
    // out[13] = ~c ^ b    -> (2,1)
    // out[12] = ~c ^ c    -> (2,2)
    // out[11] = ~c ^ d    -> (2,3)
    // out[10] = ~c ^ e    -> (2,4)
    // out[9]  = ~d ^ a    -> (3,0)
    // out[8]  = ~d ^ b    -> (3,1)
    // out[7]  = ~d ^ c    -> (3,2)
    // out[6]  = ~d ^ d    -> (3,3)
    // out[5]  = ~d ^ e    -> (3,4)
    // out[4]  = ~e ^ a    -> (4,0)
    // out[3]  = ~e ^ b    -> (4,1)
    // out[2]  = ~e ^ c    -> (4,2)
    // out[1]  = ~e ^ d    -> (4,3)
    // out[0]  = ~e ^ e    -> (4,4)

    genvar i;
    generate
        for (i = 0; i < 25; i = i +1) begin : assign_out
            // Compute row and col from output index i
            // i from 24 down to 0 maps to pairs (row,col) as above
            // Mapping: bit_index = 24 - (row*5 + col) so:
            // row = (24 - i) / 5
            // col = (24 - i) % 5
            integer row, col;
            begin
                row = (24 - i) / 5;
                col = (24 - i) % 5;
                assign out[i] = uniq_cmp[idx_uniq(row, col)];
            end
        end
    endgenerate

endmodule