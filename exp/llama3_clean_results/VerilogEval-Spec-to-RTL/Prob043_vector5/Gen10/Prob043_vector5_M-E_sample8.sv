module TopModule(a, b, c, d, e, out);
    input a, b, c, d, e;
    output [24:0] out;

    wire [4:0] inp;
    assign inp[0] = a;
    assign inp[1] = b;
    assign inp[2] = c;
    assign inp[3] = d;
    assign inp[4] = e;

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin
            for (j = 0; j < 5; j = j + 1) begin
                assign out[i * 5 + j] = ~(inp[i] ^ inp[j]);
            end
        end
    endgenerate
endmodule