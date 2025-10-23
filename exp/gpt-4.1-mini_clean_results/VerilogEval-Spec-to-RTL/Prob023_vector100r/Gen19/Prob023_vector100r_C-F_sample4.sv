module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out
);
    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin : bit_reversal
            assign out[i] = in[99 - i];
        end
    endgenerate
endmodule