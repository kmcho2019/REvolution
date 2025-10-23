module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    reg [4:0] vec = {a, b, c, d, e};
    genvar i, j;

    generate
        for (i = 0; i < 5; i++) begin
            for (j = 0; j < 5; j++) begin
                assign out[i*5 + j] = (vec[i] == vec[j]) ? 1'b1 : 1'b0;
            end
        end
    endgenerate

endmodule