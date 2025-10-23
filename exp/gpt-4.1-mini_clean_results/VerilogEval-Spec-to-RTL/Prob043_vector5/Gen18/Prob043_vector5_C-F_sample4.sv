module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    // Pack inputs into a 5-bit vector indexed 0 to 4: 0=a, 1=b, 2=c, 3=d, 4=e
    wire [4:0] inputs = {a, b, c, d, e};

    // There are 15 unique pairs in upper triangle including diagonal (i <= j)
    // We'll store them in a 15-bit vector, indexed as:
    // For i from 0 to 4, j from i to 4:
    // idx_upper(i,j) = i*5 - i*(i-1)/2 + (j - i)
    // This formula linearizes upper triangle (row-wise)

    // Precompute the number of pairs before row i: sum_{k=0}^{i-1} (5 - k)
    // = i*5 - i*(i-1)/2
    localparam int N = 5;
    localparam int NUM_UNIQUE = 15;

    wire [NUM_UNIQUE-1:0] upper_cmp;

    genvar i, j;
    generate
        for (i = 0; i < N; i = i + 1) begin : gen_i
            for (j = i; j < N; j = j + 1) begin : gen_j
                // Compute linear index for upper triangle element
                localparam int idx_upper = i*5 - (i*(i-1))/2 + (j - i);
                assign upper_cmp[idx_upper] = ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate

    // Function to get upper triangle index given i,j with i<=j
    function automatic int upper_idx(input int i_f, input int j_f);
        upper_idx = i_f*5 - (i_f*(i_f-1))/2 + (j_f - i_f);
    endfunction

    // Map full 25-bit output as per specification:
    // out[24] = a vs a = inputs[0] vs inputs[0]
    // out[23] = a vs b = inputs[0] vs inputs[1]
    // ...
    // out[0]  = e vs e = inputs[4] vs inputs[4]
    //
    // Output bits are indexed with i from 0 to 4 (rows a to e),
    // each row has bits for j=0 to 4, but bit order is from high to low:
    // For out bit index: bit = 24 - (i*5 + j)
    //
    // For pairs where i <= j: out bit takes value from upper_cmp[upper_idx(i,j)]
    // For pairs where i > j: symmetry: cmp(i,j) = cmp(j,i) = upper_cmp[upper_idx(j,i)]

    genvar k_i, k_j;
    generate
        for (k_i = 0; k_i < N; k_i = k_i + 1) begin : gen_out_i
            for (k_j = 0; k_j < N; k_j = k_j + 1) begin : gen_out_j
                localparam int bitpos = 24 - (k_i*5 + k_j);
                if (k_i <= k_j) begin
                    assign out[bitpos] = upper_cmp[upper_idx(k_i, k_j)];
                end else begin
                    assign out[bitpos] = upper_cmp[upper_idx(k_j, k_i)];
                end
            end
        end
    endgenerate

endmodule