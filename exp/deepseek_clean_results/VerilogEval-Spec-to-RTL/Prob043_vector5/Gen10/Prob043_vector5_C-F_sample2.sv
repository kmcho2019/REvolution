module TopModule (
    input a, b, c, d, e,
    output [24:0] out
);
    // Input array ordered as per problem statement (a first, e last)
    wire [4:0] inputs = {a, b, c, d, e};
    
    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : row
            for (j = 0; j < 5; j = j + 1) begin : col
                // Calculate output index to maintain exact ordering:
                // a-a (bit 24) to a-e (bit 20), b-a (bit 19) to b-e (bit 15), etc.
                assign out[(4-i)*5 + (4-j)] = inputs[i] ~^ inputs[j];
            end
        end
    endgenerate
endmodule