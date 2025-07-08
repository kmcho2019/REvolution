module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);

    // Define the inputs in an array for easier indexing
    wire [4:0] inputs = {a, b, c, d, e};

    // We'll assign out bits with indices from 0 to 24
    // Mapping pairs in order: (e,e), (e,d), (e,c), (e,b), (e,a), (d,e), (d,d), ... (a,a)
    // So for each row (outer loop) i from 4 down to 0 for inputs[i]
    // For each column (inner loop) j from 4 down to 0 for inputs[j]
    // out[idx] = ~(inputs[i] ^ inputs[j])
    // idx runs from 0 to 24 increasing per pair

    genvar i, j;
    wire [4:0] in_arr = {a,b,c,d,e}; // a at MSB index 4, e at LSB index 0

    generate
        for (i = 0; i < 5; i = i + 1) begin : row_loop
            for (j = 0; j < 5; j = j + 1) begin : col_loop
                // Calculate index in out vector:
                // Since out[0] = (e,e) = (input[4], input[4])? The example says out[0] = ~e ^ e,
                // but inputs array has a at [4], e at [0], so we need to reverse the input array or
                // map accordingly.

                // Let's build inputs array as {a,b,c,d,e} with a at index 4, e at index 0
                // To match example, index 0 corresponds to (e,e) = inputs[0], inputs[0]
                // So row i=0 corresponds to input e
                // So i,j indexes go from 0 (e) to 4 (a)

                // So index in out = i*5 + j, with i,j in [0..4]
                // out[0] = inputs[0] ^ inputs[0] = e,e
                // out[24] = inputs[4] ^ inputs[4] = a,a

                assign out[i*5 + j] = ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate

endmodule