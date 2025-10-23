module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    // Pack inputs into a vector for indexed access:
    // inputs[4] = a, inputs[3] = b, ..., inputs[0] = e
    wire [4:0] inputs = {a, b, c, d, e};

    // Function to perform bit equality via XNOR
    function bit_eq;
        input bit x, y;
        begin
            bit_eq = ~(x ^ y); // equivalently x ~^ y
        end
    endfunction

    // Wire vector to hold each pairwise comparison
    wire [24:0] pairwise_eq;

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : gen_i
            for (j = 0; j < 5; j = j + 1) begin : gen_j
                // Map (i,j) pair to out bit index:
                // bit_index = 24 - (5*i + j)
                assign pairwise_eq[24 - (5*i + j)] = bit_eq(inputs[4 - i], inputs[4 - j]);
            end
        end
    endgenerate

    // Assign the computed vector to output
    assign out = pairwise_eq;

endmodule