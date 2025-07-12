module TopModule (
    input [7:0] code,
    output [3:0] out,
    output valid
);

// Parallel matching for each valid scancode
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

// Combine all match signals
wire [9:0] matches = {match_9, match_8, match_7, match_6, 
                     match_5, match_4, match_3, match_2, 
                     match_1, match_0};

// Valid signal is OR of all matches
assign valid = |matches;

// Output encoding using priority encoder
assign out = matches[0] ? 4'd0 :
             matches[1] ? 4'd1 :
             matches[2] ? 4'd2 :
             matches[3] ? 4'd3 :
             matches[4] ? 4'd4 :
             matches[5] ? 4'd5 :
             matches[6] ? 4'd6 :
             matches[7] ? 4'd7 :
             matches[8] ? 4'd8 :
             matches[9] ? 4'd9 :
             4'd0;

endmodule