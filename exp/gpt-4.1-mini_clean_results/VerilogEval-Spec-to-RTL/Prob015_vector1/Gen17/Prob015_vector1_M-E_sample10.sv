module TopModule (
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);
    genvar i;
    // Assign low byte bits from input bits [7:0]
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_out_lo
            assign out_lo[i] = in[i];
        end
    endgenerate

    // Assign high byte bits from input bits [15:8]
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_out_hi
            assign out_hi[i] = in[i + 8];
        end
    endgenerate
endmodule