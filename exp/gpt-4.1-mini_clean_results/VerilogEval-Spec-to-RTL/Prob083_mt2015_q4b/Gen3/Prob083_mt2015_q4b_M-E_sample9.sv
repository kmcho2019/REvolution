module TopModule(
    input  wire x,
    input  wire y,
    output wire z
);

    wire nx, ny;
    wire and1, and2;

    // Invert inputs
    not u_not_x(nx, x);
    not u_not_y(ny, y);

    // AND gates for (x AND y) and (NOT x AND NOT y)
    and u_and1(and1, x, y);
    and u_and2(and2, nx, ny);

    // OR gate to combine the two AND outputs
    or u_or(z, and1, and2);

endmodule