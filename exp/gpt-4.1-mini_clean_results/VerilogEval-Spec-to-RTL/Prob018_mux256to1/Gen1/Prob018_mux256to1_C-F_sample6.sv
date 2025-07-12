module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);

wire [15:0] chunk_selected; // 16 bits selected by upper 4 bits of sel

// Select 16-bit chunk based on sel[7:4]
assign chunk_selected =
    (sel[7:4] == 4'd0)  ? in[15:0]   :
    (sel[7:4] == 4'd1)  ? in[31:16]  :
    (sel[7:4] == 4'd2)  ? in[47:32]  :
    (sel[7:4] == 4'd3)  ? in[63:48]  :
    (sel[7:4] == 4'd4)  ? in[79:64]  :
    (sel[7:4] == 4'd5)  ? in[95:80]  :
    (sel[7:4] == 4'd6)  ? in[111:96] :
    (sel[7:4] == 4'd7)  ? in[127:112]:
    (sel[7:4] == 4'd8)  ? in[143:128]:
    (sel[7:4] == 4'd9)  ? in[159:144]:
    (sel[7:4] == 4'd10) ? in[175:160]:
    (sel[7:4] == 4'd11) ? in[191:176]:
    (sel[7:4] == 4'd12) ? in[207:192]:
    (sel[7:4] == 4'd13) ? in[223:208]:
    (sel[7:4] == 4'd14) ? in[239:224]:
                          in[255:240];

// Select one bit from the selected 16-bit chunk using lower 4 bits of sel
assign out = chunk_selected[sel[3:0]];

endmodule