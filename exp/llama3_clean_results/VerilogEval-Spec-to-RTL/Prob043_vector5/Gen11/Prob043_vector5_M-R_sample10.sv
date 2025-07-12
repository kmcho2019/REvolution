module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    reg [4:0] input_array;
    assign input_array[0] = a;
    assign input_array[1] = b;
    assign input_array[2] = c;
    assign input_array[3] = d;
    assign input_array[4] = e;

    genvar i, j;
    generate
        for (i = 0; i < 5; i++) begin
            for (j = 0; j < 5; j++) begin
                assign out[i*5 + j] = ~(input_array[i] ^ input_array[j]);
            end
        end
    endgenerate

endmodule