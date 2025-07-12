module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    genvar i;
    generate
        // Map each bit of out_lo to lower byte bits of in
        for (i = 0; i < 8; i = i + 1) begin : LO_BITS
            assign out_lo[i] = in[i];
        end
        // Map each bit of out_hi to upper byte bits of in
        for (i = 0; i < 8; i = i + 1) begin : HI_BITS
            assign out_hi[i] = in[i + 8];
        end
    endgenerate

endmodule