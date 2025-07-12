module TopModule (
    input [7:0] code,
    output [3:0] out,
    output valid
);

// Individual match signals for each valid scancode
wire match_0 = (code == 8'h45);
wire match_1 = (code == 8'h16);
wire match_2 = (code == 8'h1e);
wire match_3 = (code == 8'h26);
wire match_4 = (code == 8'h25);
wire match_5 = (code == 8'h2e);
wire match_6 = (code == 8'h36);
wire match_7 = (code == 8'h3d);
wire match_8 = (code == 8'h3e);
wire match_9 = (code == 8'h46);

// Valid signal is OR of all matches
assign valid = match_0 | match_1 | match_2 | match_3 | match_4 | 
               match_5 | match_6 | match_7 | match_8 | match_9;

// Output encoding using bitwise operations
assign out[3] = match_8 | match_9;                // 8 or 9
assign out[2] = match_4 | match_5 | match_6 | match_7 | match_8 | match_9;
assign out[1] = match_2 | match_3 | match_6 | match_7 | match_9;
assign out[0] = match_1 | match_3 | match_5 | match_7 | match_9;

endmodule