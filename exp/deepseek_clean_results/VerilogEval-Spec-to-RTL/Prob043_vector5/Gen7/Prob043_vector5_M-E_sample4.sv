module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    // Input bus for easier indexing
    wire [4:0] inputs = {e, d, c, b, a};
    
    // Generate all 25 comparisons
    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : row
            for (j = 0; j < 5; j = j + 1) begin : col
                // Calculate output index: (4-i)*5 + (4-j)
                // Equivalent to 24 - (i*5 + j)
                localparam idx = (4-i)*5 + (4-j);
                // XOR + NOT implementation (same as XNOR)
                assign out[idx] = ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate

endmodule