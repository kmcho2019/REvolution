module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    // Barrel shifter inspired implementation
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : split_hi
            assign out_hi[i] = in[i+8];
        end
        for (i = 0; i < 8; i = i + 1) begin : split_lo
            assign out_lo[i] = in[i];
        end
    endgenerate

endmodule