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
        for (i = 0; i < 5; i = i + 1) begin
            for (j = 0; j < 5; j = j + 1) begin
                wire tmp;
                assign tmp = ~( inputs[i] ^ inputs[j] );
                assign out[(i * 5) + j] = tmp;
            end
        end
    endgenerate

    wire [4:0] inputs;
    assign inputs[0] = a;
    assign inputs[1] = b;
    assign inputs[2] = c;
    assign inputs[3] = d;
    assign inputs[4] = e;

endmodule