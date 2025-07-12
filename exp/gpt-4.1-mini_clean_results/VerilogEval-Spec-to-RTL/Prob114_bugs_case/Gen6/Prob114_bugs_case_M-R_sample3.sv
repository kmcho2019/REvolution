module TopModule(
    input  [7:0] code,
    output [3:0] out,
    output valid
);

    // Decode the input scancode to the digit output; default is 0
    assign out = (code == 8'h45) ? 4'd0 :
                 (code == 8'h16) ? 4'd1 :
                 (code == 8'h1e) ? 4'd2 :
                 (code == 8'h26) ? 4'd3 :
                 (code == 8'h25) ? 4'd4 :
                 (code == 8'h2e) ? 4'd5 :
                 (code == 8'h36) ? 4'd6 :
                 (code == 8'h3d) ? 4'd7 :
                 (code == 8'h3e) ? 4'd8 :
                 (code == 8'h46) ? 4'd9 : 4'd0;

    // valid is high only if code matches any recognized digit code
    assign valid = (code == 8'h45) || (code == 8'h16) || (code == 8'h1e) ||
                   (code == 8'h26) || (code == 8'h25) || (code == 8'h2e) ||
                   (code == 8'h36) || (code == 8'h3d) || (code == 8'h3e) ||
                   (code == 8'h46);

endmodule