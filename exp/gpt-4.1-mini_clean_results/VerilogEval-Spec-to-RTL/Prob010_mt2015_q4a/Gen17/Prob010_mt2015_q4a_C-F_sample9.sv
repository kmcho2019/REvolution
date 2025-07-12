module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    // Directly implement z = x & ~y with continuous assignment for best PPA
    assign z = x & ~y;
endmodule