module TopModule (
    input [7:0] code,
    output [3:0] out,
    output valid
);

// Individual valid cases
wire is_0 = (code == 8'h45);
wire is_1 = (code == 8'h16);
wire is_2 = (code == 8'h1e);
wire is_3 = (code == 8'h26);
wire is_4 = (code == 8'h25);
wire is_5 = (code == 8'h2e);
wire is_6 = (code == 8'h36);
wire is_7 = (code == 8'h3d);
wire is_8 = (code == 8'h3e);
wire is_9 = (code == 8'h46);

// Output assignment using ternary operators
assign out = is_0 ? 4'd0 :
             is_1 ? 4'd1 :
             is_2 ? 4'd2 :
             is_3 ? 4'd3 :
             is_4 ? 4'd4 :
             is_5 ? 4'd5 :
             is_6 ? 4'd6 :
             is_7 ? 4'd7 :
             is_8 ? 4'd8 :
             is_9 ? 4'd9 :
             4'd0;

// Valid signal is OR of all valid cases
assign valid = is_0 | is_1 | is_2 | is_3 | is_4 |
               is_5 | is_6 | is_7 | is_8 | is_9;

endmodule