module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    wire [4:0] in_vec = {a, b, c, d, e};
    wire [24:0] cmp_upper; // Stores upper triangle and diagonal results

    genvar i, j;
    generate
        // Compute upper triangle: i <= j
        for (i = 0; i < 5; i = i + 1) begin : gen_i
            for (j = i; j < 5; j = j + 1) begin : gen_j
                // Calculate bit index: 24 - (5*i + j)
                localparam integer bit_idx = 24 - (5*i + j);
                assign cmp_upper[bit_idx] = ~(in_vec[i] ^ in_vec[j]);
            end
        end
    endgenerate

    // Fill the lower triangle by symmetry: out[row,col] = out[col,row]
    generate
        for (i = 0; i < 5; i = i + 1) begin : gen_i2
            for (j = 0; j < i; j = j + 1) begin : gen_j2
                // lower triangle bit index: 24 - (5*i + j)
                // symmetric upper triangle bit index: 24 - (5*j + i)
                localparam integer out_idx = 24 - (5*i + j);
                localparam integer sym_idx = 24 - (5*j + i);
                assign out[out_idx] = cmp_upper[sym_idx];
            end
            // diagonal and upper triangle bits come directly from cmp_upper
            localparam integer diag_up_start = 24 - (5*i + i);
            assign out[diag_up_start -: (5 - i)] = cmp_upper[diag_up_start -: (5 - i)];
        end
    endgenerate

endmodule