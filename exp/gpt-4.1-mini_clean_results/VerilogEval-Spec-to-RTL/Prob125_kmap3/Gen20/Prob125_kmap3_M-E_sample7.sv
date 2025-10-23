module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // don't care input
    output out
);

wire [3:0] lut_c_d;

// Assign LUT values for c,d (d fixed to 0 for convenience)
assign lut_c_d[0] = 1'b0; // c=0, d=0
assign lut_c_d[1] = 1'b1; // c=0, d=1 (don't care, fixed 1)
assign lut_c_d[2] = 1'b1; // c=1, d=0
assign lut_c_d[3] = 1'b1; // c=1, d=1

// Select one of the LUT values using {a,b} as mux select lines
assign out = (a == 0 && b == 1) ? lut_c_d[{c,d}] : // ab=01
             (a == 0 && b == 0) ? 0 :
             (a == 1 && b == 0) ? 1 :
             (a == 1 && b == 1) ? 1 :
             1'b0; // Default, though all cases covered

endmodule