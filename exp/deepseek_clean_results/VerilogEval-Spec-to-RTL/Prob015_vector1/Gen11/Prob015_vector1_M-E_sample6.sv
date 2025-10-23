module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : lower_byte
            assign out_lo[i] = in[i];
        end
        for (i = 8; i < 16; i = i + 1) begin : upper_byte
            assign out_hi[i-8] = in[i];
        end
    endgenerate

endmodule