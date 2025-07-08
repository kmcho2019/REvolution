module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);

    // Create a vector with the inputs for easy indexing
    wire [4:0] inputs = {a,b,c,d,e};

    // Generate all 25 pairwise comparisons (including with self)
    // out[24] corresponds to compare a with a (inputs[4] with inputs[4])
    // out[23] corresponds to compare a with b (inputs[4] with inputs[3]), and so on
    // We arrange as in the example: out[24] = ~a ^ a; out[23] = ~a ^ b; ..., out[0] = ~e ^ e;
    
    // We'll use a generate loop to build the bits, but since output is a wire, assign it combinationally.
    // Indices mapping: for i=4 down to 0 (outer), for j=4 down to 0 (inner)
    // out index = 5*i + j
    
    // However, example shows out[24] = ~a ^ a, so index starts at 24 for (i=4,j=4)
    // So bit at index = 5*i + j
    
    // But since out[24] is highest bit, out[0] is lowest, the mapping matches
    
    genvar i, j;
    wire [24:0] comparisons;
    generate
        for (i = 0; i < 5; i = i + 1) begin : outer_loop
            for (j = 0; j < 5; j = j + 1) begin : inner_loop
                assign comparisons[5*(4 - i) + (4 - j)] = ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate

    assign out = comparisons;

endmodule