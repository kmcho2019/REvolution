module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    genvar i;

    // Assign lower byte bits 0 to 7
    generate
        for (i = 0; i < 8; i = i + 1) begin : assign_lo_bits
            assign out_lo[i] = in[i];
        end
    endgenerate

    // Assign upper byte bits 0 to 7 from in[15:8]
    generate
        for (i = 0; i < 8; i = i + 1) begin : assign_hi_bits
            assign out_hi[i] = in[i + 8];
        end
    endgenerate

endmodule