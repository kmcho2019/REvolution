module TopModule(
    input  [7:0] code,
    output [3:0] out,
    output valid
);

    // One-hot match signals for each recognized scancode
    wire match0 = (code == 8'h45);
    wire match1 = (code == 8'h16);
    wire match2 = (code == 8'h1E);
    wire match3 = (code == 8'h26);
    wire match4 = (code == 8'h25);
    wire match5 = (code == 8'h2E);
    wire match6 = (code == 8'h36);
    wire match7 = (code == 8'h3D);
    wire match8 = (code == 8'h3E);
    wire match9 = (code == 8'h46);

    // valid if any match is true
    assign valid = match0 | match1 | match2 | match3 | match4 |
                   match5 | match6 | match7 | match8 | match9;

    // 4-bit output encoding using parallel priority encoder logic
    assign out = ({4{match0}} & 4'd0) |
                 ({4{match1}} & 4'd1) |
                 ({4{match2}} & 4'd2) |
                 ({4{match3}} & 4'd3) |
                 ({4{match4}} & 4'd4) |
                 ({4{match5}} & 4'd5) |
                 ({4{match6}} & 4'd6) |
                 ({4{match7}} & 4'd7) |
                 ({4{match8}} & 4'd8) |
                 ({4{match9}} & 4'd9);

endmodule