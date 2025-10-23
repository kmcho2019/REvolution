module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    wire [4:0] in_bits = {a, b, c, d, e}; // in_bits[4]=a, [3]=b, ..., [0]=e

    genvar i, j;
    wire [24:0] temp_out;

    generate
        for (i = 0; i < 5; i = i + 1) begin : loop_i
            for (j = 0; j < 5; j = j + 1) begin : loop_j
                // Compute index: pairs (a,a),(a,b),...,(e,e) mapped to out[24:0]
                // Since in_bits[4]=a,...[0]=e, to map out[24]=(a,a) which is in_bits[4], so
                // output index = 24 - (i*5 + j), but since i,j run 0..4 corresponding to in_bits[4-i], we need to invert i,j:
                // Let's fix mapping: i,j from 0..4 correspond to inputs in order a,b,c,d,e as in_bits[4],in_bits[3],...in_bits[0]
                // So in_bits_idx = 4 - i and 4 - j

                localparam int out_idx = 24 - (i*5 + j);
                localparam int idx_i = 4 - i;
                localparam int idx_j = 4 - j;

                assign temp_out[out_idx] = ~(in_bits[idx_i] ^ in_bits[idx_j]);
            end
        end
    endgenerate

    assign out = temp_out;

endmodule