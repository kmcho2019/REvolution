module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    // Bundle inputs into a vector for systematic access
    wire [4:0] inputs = {e, d, c, b, a};
    
    // Generate all pairwise comparisons
    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : row
            for (j = 0; j < 5; j = j + 1) begin : col
                // Calculate output bit position: (4-i)*5 + (4-j)
                localparam bit_pos = (4-i)*5 + (4-j);
                if (i == j) begin
                    // Diagonal elements are always 1
                    assign out[bit_pos] = 1'b1;
                end else begin
                    // Off-diagonal elements use XNOR comparison
                    assign out[bit_pos] = ~(inputs[i] ^ inputs[j]);
                end
            end
        end
    endgenerate

endmodule