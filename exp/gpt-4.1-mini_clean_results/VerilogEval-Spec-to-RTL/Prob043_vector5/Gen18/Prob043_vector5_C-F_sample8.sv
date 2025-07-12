module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    // Pack inputs into 5-bit vector indexed [4:0] = {a,b,c,d,e}
    wire [4:0] inputs = {a, b, c, d, e};

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : gen_i
            for (j = 0; j < 5; j = j + 1) begin : gen_j
                localparam int idx = i*5 + j;
                if (i >= j) begin
                    // For lower triangle and diagonal, compute XNOR of inputs[i], inputs[j]
                    assign out[24 - idx] = inputs[4 - i] ~^ inputs[4 - j];
                end else begin
                    // For upper triangle, reuse symmetric bit: out[24 - idx] = out[24 - (j*5 + i)]
                    assign out[24 - idx] = out[24 - (j*5 + i)];
                end
            end
        end
    endgenerate

endmodule