module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);
    // Array of inputs for indexed access
    wire [4:0] inputs = {a, b, c, d, e};
    
    genvar i, j;
    generate
        // Assign each out bit: out[24 - (5*i + j)] = (inputs[i] == inputs[j])
        // Because output[24] corresponds to (a,a) = inputs[0], inputs[0]
        for (i = 0; i < 5; i = i + 1) begin : row_loop
            for (j = 0; j < 5; j = j + 1) begin : col_loop
                // Calculate bit index
                localparam int bit_idx = 24 - (5*i + j);
                assign out[bit_idx] = (inputs[i] == inputs[j]);
            end
        end
    endgenerate
endmodule