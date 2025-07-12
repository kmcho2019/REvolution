module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    // Bundle inputs in reverse order for direct mapping
    wire [4:0] inputs = {a, b, c, d, e};
    
    // Generate all pairwise comparisons
    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : row
            for (j = 0; j < 5; j = j + 1) begin : col
                // Calculate output bit position: i*5 + j
                localparam bit_pos = i*5 + j;
                assign out[bit_pos] = (i == j) ? 1'b1 : ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate

endmodule