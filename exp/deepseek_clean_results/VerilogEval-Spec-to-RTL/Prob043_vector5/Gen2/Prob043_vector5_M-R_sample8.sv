module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    // Pack all inputs into an array for easy indexing
    wire [4:0] inputs = {a, b, c, d, e};

    // Generate all pairwise comparisons
    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : row
            for (j = 0; j < 5; j = j + 1) begin : col
                // Calculate the proper index (24 downto 0)
                localparam idx = (4-i)*5 + (4-j);
                assign out[idx] = ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate

endmodule