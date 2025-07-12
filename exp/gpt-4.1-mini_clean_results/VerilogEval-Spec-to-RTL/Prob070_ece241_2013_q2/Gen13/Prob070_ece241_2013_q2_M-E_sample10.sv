module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    wire [3:0] in_vec = {a,b,c,d};

    // Define one-hot outputs for ones set (2,7,15)
    wire match_2  = (in_vec == 4'd2);
    wire match_7  = (in_vec == 4'd7);
    wire match_15 = (in_vec == 4'd15);

    // Define one-hot outputs for zeros set (0,1,4,5,6,9,10,13,14)
    wire match_0  = (in_vec == 4'd0);
    wire match_1  = (in_vec == 4'd1);
    wire match_4  = (in_vec == 4'd4);
    wire match_5  = (in_vec == 4'd5);
    wire match_6  = (in_vec == 4'd6);
    wire match_9  = (in_vec == 4'd9);
    wire match_10 = (in_vec == 4'd10);
    wire match_13 = (in_vec == 4'd13);
    wire match_14 = (in_vec == 4'd14);

    // Output is 1 if input matches any of the "ones" values
    assign out_sop = match_2 | match_7 | match_15;

    // Output is 0 if input matches any of the "zeros" values, else 1
    assign out_pos = ~(match_0 | match_1 | match_4 | match_5 | match_6 | match_9 | match_10 | match_13 | match_14);

endmodule