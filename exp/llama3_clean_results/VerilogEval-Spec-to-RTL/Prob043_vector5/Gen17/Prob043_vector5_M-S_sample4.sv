module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    genvar i;
    generate
        for (i = 0; i < 25; i++) begin
            assign out[i] = ( {a, b, c, d, e}[(i / 5)] == {a, b, c, d, e}[(i % 5)] ) ? 1'b1 : 1'b0;
        end
    endgenerate

endmodule