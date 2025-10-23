module TopModule(a, b, c, d, e, out);
    input a, b, c, d, e;
    output [24:0] out;

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin
            for (j = 0; j < 5; j = j + 1) begin
                wire [4:0] inputs = {a, b, c, d, e};
                assign out[(i * 5) + j] = ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate
endmodule