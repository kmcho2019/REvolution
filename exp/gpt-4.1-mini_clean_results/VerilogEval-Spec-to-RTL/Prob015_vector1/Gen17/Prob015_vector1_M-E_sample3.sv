module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    // Explicit bit-wise assignments for upper byte
    assign out_hi[7] = in[15];
    assign out_hi[6] = in[14];
    assign out_hi[5] = in[13];
    assign out_hi[4] = in[12];
    assign out_hi[3] = in[11];
    assign out_hi[2] = in[10];
    assign out_hi[1] = in[9];
    assign out_hi[0] = in[8];

    // Explicit bit-wise assignments for lower byte
    assign out_lo[7] = in[7];
    assign out_lo[6] = in[6];
    assign out_lo[5] = in[5];
    assign out_lo[4] = in[4];
    assign out_lo[3] = in[3];
    assign out_lo[2] = in[2];
    assign out_lo[1] = in[1];
    assign out_lo[0] = in[0];

endmodule