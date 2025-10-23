module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    wire ny; // Internal wire for NOT y

    not Unot (ny, y);   // Invert y
    and Uand (z, x, ny); // AND x and inverted y
endmodule