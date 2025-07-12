module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

genvar i, j;
wire [4:0] signals = {a, b, c, d, e};

generate
    for (i = 0; i < 5; i++) begin
        for (j = 0; j < 5; j++) begin
            assign out[i*5 + j] = (signals[i] == signals[j]);
        end
    end
endgenerate

endmodule