module TopModule (
    input [7:0] code,
    output [3:0] out,
    output valid
);

// Parallel comparison for each valid scancode
wire [9:0] matches = {
    code == 8'h46,  // 9
    code == 8'h3e,  // 8
    code == 8'h3d,  // 7
    code == 8'h36,  // 6
    code == 8'h2e,  // 5
    code == 8'h25,  // 4
    code == 8'h26,  // 3
    code == 8'h1e,  // 2
    code == 8'h16,  // 1
    code == 8'h45   // 0
};

// Priority encoder for matches
assign out = 
    matches[9] ? 4'd9 :
    matches[8] ? 4'd8 :
    matches[7] ? 4'd7 :
    matches[6] ? 4'd6 :
    matches[5] ? 4'd5 :
    matches[4] ? 4'd4 :
    matches[3] ? 4'd3 :
    matches[2] ? 4'd2 :
    matches[1] ? 4'd1 :
    matches[0] ? 4'd0 :
    4'd0;

// Valid signal is OR of all matches
assign valid = |matches;

endmodule