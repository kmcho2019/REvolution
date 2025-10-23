module TopModule (
    input [7:0] code,
    output [3:0] out,
    output valid
);

// Output assignments using ternary operators
assign out = (code == 8'h45) ? 0 :
             (code == 8'h16) ? 1 :
             (code == 8'h1e) ? 2 :
             (code == 8'h26) ? 3 :
             (code == 8'h25) ? 4 :
             (code == 8'h2e) ? 5 :
             (code == 8'h36) ? 6 :
             (code == 8'h3d) ? 7 :
             (code == 8'h3e) ? 8 :
             (code == 8'h46) ? 9 : 0;

// Valid signal is high when any valid code is detected
assign valid = (code == 8'h45) ||
               (code == 8'h16) ||
               (code == 8'h1e) ||
               (code == 8'h26) ||
               (code == 8'h25) ||
               (code == 8'h2e) ||
               (code == 8'h36) ||
               (code == 8'h3d) ||
               (code == 8'h3e) ||
               (code == 8'h46);

endmodule