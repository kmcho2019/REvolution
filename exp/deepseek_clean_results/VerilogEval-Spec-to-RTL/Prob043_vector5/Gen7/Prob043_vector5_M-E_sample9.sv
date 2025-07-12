module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    // Pack inputs into a vector for systematic access
    wire [4:0] inputs = {a, b, c, d, e};

    // Generate all 25 pairwise comparisons
    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : row
            for (j = 0; j < 5; j = j + 1) begin : col
                // Calculate output index: (4-i)*5 + (4-j)
                localparam idx = (4-i)*5 + (4-j);
                assign out[idx] = ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate

endmodule