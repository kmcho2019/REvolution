module TopModule(
    input [255:0] in, // 256-bit input vector
    input [7:0] sel, // 8-bit select signal
    output out // 1-bit output
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

    // Use a 4-to-1 multiplexer to select one of the chunks
    wire [15:0] selected_chunk;
    always @(*) begin
        case (sel[7:4])
            4'd0: selected_chunk = chunk0;
            4'd1: selected_chunk = chunk1;
            4'd2: selected_chunk = chunk2;
            4'd3: selected_chunk = chunk3;
            4'd4: selected_chunk = chunk4;
            4'd5: selected_chunk = chunk5;
            4'd6: selected_chunk = chunk6;
            4'd7: selected_chunk = chunk7;
            4'd8: selected_chunk = chunk8;
            4'd9: selected_chunk = chunk9;
            4'd10: selected_chunk = chunk10;
            4'd11: selected_chunk = chunk11;
            4'd12: selected_chunk = chunk12;
            4'd13: selected_chunk = chunk13;
            4'd14: selected_chunk = chunk14;
            4'd15: selected_chunk = chunk15;
            default: selected_chunk = 16'd0;
        endcase
    end

    // Use a 16-to-1 multiplexer to select the desired bit within the selected chunk
    assign out = selected_chunk[sel[3:0]];

endmodule