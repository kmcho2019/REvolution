module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);

    // Directly assign input vector to output vector
    assign outv = vec;

    // Declare an internal wire array to hold split bits
    wire [2:0] split_bits;

    // Use generate-for loop to assign each bit
    genvar i;
    generate
        for (i = 0; i < 3; i = i + 1) begin : SPLIT
            assign split_bits[i] = vec[i];
        end
    endgenerate

    // Connect split_bits to individual outputs
    assign o0 = split_bits[0];
    assign o1 = split_bits[1];
    assign o2 = split_bits[2];

endmodule