module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);
    wire [4:0] inputs = {a, b, c, d, e};
    wire [24:0] temp_out;

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : outer
            for (j = 0; j < 5; j = j + 1) begin : inner
                // Calculate bit position from i and j
                // Position = (4 - i)*5 + (4 - j) matches example order (MSB = a_a)
                localparam int pos = (4 - i)*5 + (4 - j);
                assign temp_out[pos] = ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate

    assign out = temp_out;
endmodule