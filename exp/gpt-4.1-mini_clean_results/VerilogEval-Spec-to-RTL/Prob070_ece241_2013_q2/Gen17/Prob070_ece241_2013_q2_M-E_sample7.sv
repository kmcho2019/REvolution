module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);
    wire [3:0] num;
    assign num = {a, b, c, d};

    // out_sop = 1 if num == 2, 7, or 15
    assign out_sop = (num == 4'd2) | (num == 4'd7) | (num == 4'd15);

    // out_pos = 1 if num not in {0,1,4,5,6,9,10,13,14}
    wire zero_match;
    assign zero_match = (num == 4'd0) | (num == 4'd1) | (num == 4'd4) | (num == 4'd5) |
                        (num == 4'd6) | (num == 4'd9) | (num == 4'd10) | (num == 4'd13) | (num == 4'd14);
    assign out_pos = ~zero_match;

endmodule