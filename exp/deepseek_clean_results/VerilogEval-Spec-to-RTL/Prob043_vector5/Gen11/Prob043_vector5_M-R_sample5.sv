module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    // Pack input signals into array for systematic processing
    wire [4:0] signals = {a, b, c, d, e};
    
    // Generate all 25 pairwise comparisons (5x5 matrix)
    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : row
            for (j = 0; j < 5; j = j + 1) begin : col
                // Calculate output index: (4-i)*5 + (4-j)
                localparam idx = (4-i)*5 + (4-j);
                
                // Self-comparison -> 1, else XNOR comparison
                if (i == j) begin
                    assign out[idx] = 1'b1;
                end else begin
                    assign out[idx] = signals[i] ~^ signals[j];
                end
            end
        end
    endgenerate

    /* Resulting comparison matrix mapping:
       out[24:20] = a vs [a,b,c,d,e]
       out[19:15] = b vs [a,b,c,d,e]
       out[14:10] = c vs [a,b,c,d,e]
       out[9:5]   = d vs [a,b,c,d,e]
       out[4:0]   = e vs [a,b,c,d,e]
    */

endmodule