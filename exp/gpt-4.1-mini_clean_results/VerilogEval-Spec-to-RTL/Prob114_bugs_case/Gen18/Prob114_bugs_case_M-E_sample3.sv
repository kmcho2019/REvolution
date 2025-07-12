module TopModule(
    input  [7:0] code,
    output [3:0] out,
    output valid
);

    // One-hot match wires for each known scancode
    wire match0 = (code == 8'h45);
    wire match1 = (code == 8'h16);
    wire match2 = (code == 8'h1e);
    wire match3 = (code == 8'h26);
    wire match4 = (code == 8'h25);
    wire match5 = (code == 8'h2e);
    wire match6 = (code == 8'h36);
    wire match7 = (code == 8'h3d);
    wire match8 = (code == 8'h3e);
    wire match9 = (code == 8'h46);

    // Valid is asserted if any match is detected
    assign valid = match0 | match1 | match2 | match3 | match4 | match5 | match6 | match7 | match8 | match9;

    // Output digit is selected based on which match is true
    // If none matches, out = 0 by default
    assign out =   (match0 ? 4'd0 :
                   (match1 ? 4'd1 :
                   (match2 ? 4'd2 :
                   (match3 ? 4'd3 :
                   (match4 ? 4'd4 :
                   (match5 ? 4'd5 :
                   (match6 ? 4'd6 :
                   (match7 ? 4'd7 :
                   (match8 ? 4'd8 :
                   (match9 ? 4'd9 :
                              4'd0))))))))));

endmodule