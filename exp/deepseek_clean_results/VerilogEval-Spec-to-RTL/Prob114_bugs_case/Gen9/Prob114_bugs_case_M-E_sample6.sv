module TopModule (
    input [7:0] code,
    output [3:0] out,
    output valid
);

// Create match signals for each valid scancode
wire [9:0] matches = {
    code == 8'h46,  // Position 9 = digit 9
    code == 8'h3e,  // Position 8 = digit 8
    code == 8'h3d,  // Position 7 = digit 7
    code == 8'h36,  // Position 6 = digit 6
    code == 8'h2e,  // Position 5 = digit 5
    code == 8'h25,  // Position 4 = digit 4
    code == 8'h26,  // Position 3 = digit 3
    code == 8'h1e,  // Position 2 = digit 2
    code == 8'h16,  // Position 1 = digit 1
    code == 8'h45   // Position 0 = digit 0
};

// Valid is OR of all matches
assign valid = |matches;

// Output is the binary encoding of the highest priority match
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

endmodule