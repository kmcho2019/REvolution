module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

genvar i, j;
generate
    for (i = 0; i < 5; i++) begin
        for (j = 0; j < 5; j++) begin
            assign out[i*5 + j] = ~(inputs[i] ^ inputs[j]);
        end
    end
endgenerate

wire [4:0] inputs = {a, b, c, d, e};

endmodule