module TopModule(
    input [255:0] in,  // 256-bit input vector
    input [7:0] sel,   // 8-bit select line
    output out          // 1-bit output
);

    // Divide the input vector into 16 chunks of 16 bits each
    wire [15:0] chunk0 = in[15:0];
    wire [15:0] chunk1 = in[31:16];
    wire [15:0] chunk2 = in[47:32];
    wire [15:0] chunk3 = in[63:48];
    wire [15:0] chunk4 = in[79:64];
    wire [15:0] chunk5 = in[95:80];
    wire [15:0] chunk6 = in[111:96];
    wire [15:0] chunk7 = in[127:112];
    wire [15:0] chunk8 = in[143:128];
    wire [15:0] chunk9 = in[159:144];
    wire [15:0] chunk10 = in[175:160];
    wire [15:0] chunk11 = in[191:176];
    wire [15:0] chunk12 = in[207:192];
    wire [15:0] chunk13 = in[223:208];
    wire [15:0] chunk14 = in[239:224];
    wire [15:0] chunk15 = in[255:240];

    // Use 16 16-to-1 multiplexers to select from each chunk
    wire [15:0] mux_out;
    mux_16to1 mux0(chunk0, sel[3:0], mux_out[0]);
    mux_16to1 mux1(chunk1, sel[3:0], mux_out[1]);
    mux_16to1 mux2(chunk2, sel[3:0], mux_out[2]);
    mux_16to1 mux3(chunk3, sel[3:0], mux_out[3]);
    mux_16to1 mux4(chunk4, sel[3:0], mux_out[4]);
    mux_16to1 mux5(chunk5, sel[3:0], mux_out[5]);
    mux_16to1 mux6(chunk6, sel[3:0], mux_out[6]);
    mux_16to1 mux7(chunk7, sel[3:0], mux_out[7]);
    mux_16to1 mux8(chunk8, sel[3:0], mux_out[8]);
    mux_16to1 mux9(chunk9, sel[3:0], mux_out[9]);
    mux_16to1 mux10(chunk10, sel[3:0], mux_out[10]);
    mux_16to1 mux11(chunk11, sel[3:0], mux_out[11]);
    mux_16to1 mux12(chunk12, sel[3:0], mux_out[12]);
    mux_16to1 mux13(chunk13, sel[3:0], mux_out[13]);
    mux_16to1 mux14(chunk14, sel[3:0], mux_out[14]);
    mux_16to1 mux15(chunk15, sel[3:0], mux_out[15]);

    // Use a final 16-to-1 multiplexer to select the final output bit
    mux_16to1 mux_final(mux_out, sel[7:4], out);

endmodule

// Define the 16-to-1 multiplexer module
module mux_16to1(
    input [15:0] in,  // 16-bit input vector
    input [3:0] sel,  // 4-bit select line
    output out        // 1-bit output
);

    assign out = in[sel];

endmodule