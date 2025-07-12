module TopModule(
    input  [7:0] code,
    output [3:0] out,
    output valid
);

    parameter [7:0] scancode_0 = 8'h45;
    parameter [7:0] scancode_1 = 8'h16;
    parameter [7:0] scancode_2 = 8'h1e;
    parameter [7:0] scancode_3 = 8'h26;
    parameter [7:0] scancode_4 = 8'h25;
    parameter [7:0] scancode_5 = 8'h2e;
    parameter [7:0] scancode_6 = 8'h36;
    parameter [7:0] scancode_7 = 8'h3d;
    parameter [7:0] scancode_8 = 8'h3e;
    parameter [7:0] scancode_9 = 8'h46;

    assign valid = (code == scancode_0) || (code == scancode_1) || (code == scancode_2) ||
                    (code == scancode_3) || (code == scancode_4) || (code == scancode_5) ||
                    (code == scancode_6) || (code == scancode_7) || (code == scancode_8) ||
                    (code == scancode_9);

    assign out = (code == scancode_0) ? 4'd0 :
                 (code == scancode_1) ? 4'd1 :
                 (code == scancode_2) ? 4'd2 :
                 (code == scancode_3) ? 4'd3 :
                 (code == scancode_4) ? 4'd4 :
                 (code == scancode_5) ? 4'd5 :
                 (code == scancode_6) ? 4'd6 :
                 (code == scancode_7) ? 4'd7 :
                 (code == scancode_8) ? 4'd8 :
                 (code == scancode_9) ? 4'd9 : 4'd0;

endmodule