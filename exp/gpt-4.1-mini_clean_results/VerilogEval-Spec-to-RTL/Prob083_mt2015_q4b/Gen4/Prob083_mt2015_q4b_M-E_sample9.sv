module TopModule(
    input  wire x,
    input  wire y,
    output wire z
);

    wire nx;

    // Invert x
    not u_not_x(nx, x);

    // Multiplexer: if y=0 -> z=nx; if y=1 -> z=x
    assign z = y ? x : nx;

endmodule