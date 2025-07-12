module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    // Pack inputs as vector [4:0] = {a,b,c,d,e}
    wire [4:0] inputs = {a, b, c, d, e};

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : outer
            for (j = 0; j < 5; j = j + 1) begin : inner
                // Calculate bit index: bits from 24 down to 0
                localparam int bit_idx = 5 * i + j;
                // out[24 - bit_idx] corresponds to inputs[i] ~^ inputs[j]
                assign out[24 - bit_idx] = inputs[i] ~^ inputs[j];
            end
        end
    endgenerate

endmodule