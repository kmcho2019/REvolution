module TopModule (
    input [7:0] code,
    output [3:0] out,
    output valid
);

// Key 0
wire match_0 = (code == 8'h45);
// Key 1
wire match_1 = (code == 8'h16);
// Key 2
wire match_2 = (code == 8'h1e);
// Key 3
wire match_3 = (code == 8'h26);
// Key 4
wire match_4 = (code == 8'h25);
// Key 5
wire match_5 = (code == 8'h2e);
// Key 6
wire match_6 = (code == 8'h36);
// Key 7
wire match_7 = (code == 8'h3d);
// Key 8
wire match_8 = (code == 8'h3e);
// Key 9
wire match_9 = (code == 8'h46);

// Output assignments
assign out[0] = match_1 | match_3 | match_5 | match_7 | match_9;
assign out[1] = match_2 | match_3 | match_6 | match_7;
assign out[2] = match_4 | match_5 | match_6 | match_7;
assign out[3] = match_8 | match_9;

assign valid = match_0 | match_1 | match_2 | match_3 | match_4 |
               match_5 | match_6 | match_7 | match_8 | match_9;

endmodule