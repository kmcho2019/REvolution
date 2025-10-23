module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos   // 3-bit output
);

    wire [7:0] half1, half2;
    assign half1 = in[7:4];
    assign half2 = in[3:0];

    wire has_1_in_half1, has_1_in_half2;
    assign has_1_in_half1 = |half1;
    assign has_1_in_half2 = |half2;

    wire [1:0] quarter;
    assign quarter = has_1_in_half1 ? (|in[7:6]) : (|in[3:2]);

    assign pos = 
    (has_1_in_half1 && |in[7:6] && in[7]) ? 3'd7 :
    (has_1_in_half1 && |in[7:6] && in[6]) ? 3'd6 :
    (has_1_in_half1 && |in[5:4] && in[5]) ? 3'd5 :
    (has_1_in_half1 && |in[5:4] && in[4]) ? 3'd4 :
    (has_1_in_half2 && |in[3:2] && in[3]) ? 3'd3 :
    (has_1_in_half2 && |in[3:2] && in[2]) ? 3'd2 :
    (has_1_in_half2 && |in[1:0] && in[1]) ? 3'd1 :
    (has_1_in_half2 && |in[1:0] && in[0]) ? 3'd0 :
    3'd0;

endmodule