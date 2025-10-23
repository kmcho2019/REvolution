module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);

xnor u_xnor_z (z, x, y);

endmodule