module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out
);

    genvar i;
    for (i = 0; i < 100; i = i + 1)
        assign out[i] = in[99 - i];

endmodule