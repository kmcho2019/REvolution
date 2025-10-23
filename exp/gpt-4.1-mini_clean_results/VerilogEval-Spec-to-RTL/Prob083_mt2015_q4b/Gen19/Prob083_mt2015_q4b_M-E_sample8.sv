module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);

wire nx;      // not x
wire and_high; // x & y
wire and_low;  // ~x & ~y

not u_not_x (nx, x);
and u_and_high (and_high, x, y);
and u_and_low (and_low, nx, ~y);
or  u_or_z (z, and_high, and_low);

endmodule