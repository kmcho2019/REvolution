module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    wire [7:0] hi_bits;
    wire [7:0] lo_bits;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : bit_split
            assign hi_bits[i] = in[i + 8];
            assign lo_bits[i] = in[i];
        end
    endgenerate

    assign out_hi = hi_bits;
    assign out_lo = lo_bits;

endmodule