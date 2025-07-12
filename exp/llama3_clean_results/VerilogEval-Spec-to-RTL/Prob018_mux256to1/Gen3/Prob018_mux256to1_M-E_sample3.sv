module TopModule(
    input [255:0] in, // 256-bit input vector
    input [7:0] sel, // 8-bit select input
    output out // 1-bit output
);

    // Define the 16-to-1 multiplexer module
    module mux16(
        input [15:0] in, // 16-bit input vector
        input [3:0] sel, // 4-bit select input
        output out // 1-bit output
    );
        assign out = in[sel];
    endmodule

    // Divide the 256-bit input into 16 chunks of 16 bits each
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

    // Use the upper 4 bits of sel to select one of the 16 chunks
    wire [3:0] chunk_sel = sel[7:4];
    wire [15:0] selected_chunk;
    mux16 mux0(chunk0, chunk_sel, selected_chunk[0]);
    mux16 mux1(chunk1, chunk_sel, selected_chunk[1]);
    mux16 mux2(chunk2, chunk_sel, selected_chunk[2]);
    mux16 mux3(chunk3, chunk_sel, selected_chunk[3]);
    mux16 mux4(chunk4, chunk_sel, selected_chunk[4]);
    mux16 mux5(chunk5, chunk_sel, selected_chunk[5]);
    mux16 mux6(chunk6, chunk_sel, selected_chunk[6]);
    mux16 mux7(chunk7, chunk_sel, selected_chunk[7]);
    mux16 mux8(chunk8, chunk_sel, selected_chunk[8]);
    mux16 mux9(chunk9, chunk_sel, selected_chunk[9]);
    mux16 mux10(chunk10, chunk_sel, selected_chunk[10]);
    mux16 mux11(chunk11, chunk_sel, selected_chunk[11]);
    mux16 mux12(chunk12, chunk_sel, selected_chunk[12]);
    mux16 mux13(chunk13, chunk_sel, selected_chunk[13]);
    mux16 mux14(chunk14, chunk_sel, selected_chunk[14]);
    mux16 mux15(chunk15, chunk_sel, selected_chunk[15]);

    // Use the lower 4 bits of sel to select one bit from the selected chunk
    wire [3:0] bit_sel = sel[3:0];
    assign out = selected_chunk[bit_sel];

endmodule