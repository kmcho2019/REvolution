module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);

// Single XNOR gate primitive for minimal and explicit gate-level implementation
xnor u_xnor (z, x, y);

endmodule