module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);
    // Pack inputs into an array for indexed access
    wire [4:0] inputs = {a, b, c, d, e};

    genvar i, j;
    // We know output[24 - (i*5 + j)] = ~(inputs[i] ^ inputs[j])
    // Because for i,j from 0 to 4, output bits run from 24 down to 0
    generate
        for (i = 0; i < 5; i = i + 1) begin : outer
            for (j = 0; j < 5; j = j + 1) begin : inner
                localparam int out_idx = 24 - (i*5 + j);
                // For diagonal elements (i == j), hardwire to 1 as bits equal themselves
                if (i == j) begin
                    assign out[out_idx] = 1'b1;
                end else begin
                    assign out[out_idx] = ~(inputs[i] ^ inputs[j]); // XNOR for equality
                end
            end
        end
    endgenerate

endmodule