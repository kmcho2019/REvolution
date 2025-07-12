module TopModule (
    input [7:0] code,
    output [3:0] out,
    output valid
);

// Valid signal is OR of all valid codes
assign valid = (code == 8'h45) || (code == 8'h16) || (code == 8'h1e) ||
               (code == 8'h26) || (code == 8'h25) || (code == 8'h2e) ||
               (code == 8'h36) || (code == 8'h3d) || (code == 8'h3e) ||
               (code == 8'h46);

// Output bits computed independently
assign out[0] = (code == 8'h16) || (code == 8'h25) || (code == 8'h3d) || (code == 8'h46);
assign out[1] = (code == 8'h1e) || (code == 8'h25) || (code == 8'h2e) || (code == 8'h36) || (code == 8'h3e);
assign out[2] = (code == 8'h26) || (code == 8'h2e) || (code == 8'h36) || (code == 8'h3d) || (code == 8'h3e) || (code == 8'h46);
assign out[3] = (code == 8'h36) || (code == 8'h3d) || (code == 8'h3e) || (code == 8'h46);

endmodule