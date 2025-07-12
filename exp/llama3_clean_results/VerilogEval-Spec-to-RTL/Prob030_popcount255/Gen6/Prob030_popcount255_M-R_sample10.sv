module TopModule(
    input [254:0] in,
    output [7:0] out
);

    wire [4:0] segment0, segment1, segment2, segment3, segment4, segment5, segment6, segment7, segment8, segment9, segment10, segment11, segment12, segment13, segment14, segment15;

    assign segment0 = in[15:0] + {{15{1'b0}}, 1'b1};
    assign segment1 = in[31:16] + {{15{1'b0}}, 1'b1};
    assign segment2 = in[47:32] + {{15{1'b0}}, 1'b1};
    assign segment3 = in[63:48] + {{15{1'b0}}, 1'b1};
    assign segment4 = in[79:64] + {{15{1'b0}}, 1'b1};
    assign segment5 = in[95:80] + {{15{1'b0}}, 1'b1};
    assign segment6 = in[111:96] + {{15{1'b0}}, 1'b1};
    assign segment7 = in[127:112] + {{15{1'b0}}, 1'b1};
    assign segment8 = in[143:128] + {{15{1'b0}}, 1'b1};
    assign segment9 = in[159:144] + {{15{1'b0}}, 1'b1};
    assign segment10 = in[175:160] + {{15{1'b0}}, 1'b1};
    assign segment11 = in[191:176] + {{15{1'b0}}, 1'b1};
    assign segment12 = in[207:192] + {{15{1'b0}}, 1'b1};
    assign segment13 = in[223:208] + {{15{1'b0}}, 1'b1};
    assign segment14 = in[239:224] + {{15{1'b0}}, 1'b1};
    assign segment15 = in[254:240] + {{7{1'b0}}, 1'b1};

    assign out = segment0 + segment1 + segment2 + segment3 + segment4 + segment5 + segment6 + segment7 + segment8 + segment9 + segment10 + segment11 + segment12 + segment13 + segment14 + segment15;

endmodule