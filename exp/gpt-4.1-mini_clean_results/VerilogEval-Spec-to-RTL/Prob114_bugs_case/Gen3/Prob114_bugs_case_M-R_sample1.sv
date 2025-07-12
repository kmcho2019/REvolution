module TopModule(
    input  [7:0] code,
    output [3:0] out,
    output valid
);

// One-hot signals for each recognized scancode
wire match_0  = (code == 8'h45);
wire match_1  = (code == 8'h16);
wire match_2  = (code == 8'h1E);
wire match_3  = (code == 8'h26);
wire match_4  = (code == 8'h25);
wire match_5  = (code == 8'h2E);
wire match_6  = (code == 8'h36);
wire match_7  = (code == 8'h3D);
wire match_8  = (code == 8'h3E);
wire match_9  = (code == 8'h46);

assign valid = match_0 | match_1 | match_2 | match_3 | match_4 | match_5 | match_6 | match_7 | match_8 | match_9;

// Generate output based on which key matched, default to 0 if no match
assign out = {4{match_0}} & 4'd0 |
             {4{match_1}} & 4'd1 |
             {4{match_2}} & 4'd2 |
             {4{match_3}} & 4'd3 |
             {4{match_4}} & 4'd4 |
             {4{match_5}} & 4'd5 |
             {4{match_6}} & 4'd6 |
             {4{match_7}} & 4'd7 |
             {4{match_8}} & 4'd8 |
             {4{match_9}} & 4'd9 |
             {4{~valid}} & 4'd0;

endmodule