module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    // Pack inputs into an array indexed 0 to 4 as {a,b,c,d,e} = {inputs[4],...,inputs[0]}
    wire [4:0] inputs = {a, b, c, d, e};

    genvar i, j;
    // Temporary vector to hold partial results
    wire [24:0] temp_out;

    generate
        for (i = 0; i < 5; i = i + 1) begin : outer_loop
            for (j = 0; j < 5; j = j + 1) begin : inner_loop
                // Calculate bit position matching original indexing:
                // bit_pos = 5*(4 - i) + (4 - j)
                localparam integer bit_pos = 5*(4 - i) + (4 - j);
                assign temp_out[bit_pos] = ~(inputs[i] ^ inputs[j]); // XNOR
            end
        end
    endgenerate

    assign out = temp_out;

endmodule