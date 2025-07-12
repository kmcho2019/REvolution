module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    wire [4:0] bits;
    assign bits[0] = a;
    assign bits[1] = b;
    assign bits[2] = c;
    assign bits[3] = d;
    assign bits[4] = e;

    genvar i, j;
    generate
        for (i = 0; i < 5; i++) begin
            for (j = 0; j < 5; j++) begin
                assign out[i*5 + j] = ~(bits[i] ^ bits[j]);
            end
        end
    endgenerate

endmodule