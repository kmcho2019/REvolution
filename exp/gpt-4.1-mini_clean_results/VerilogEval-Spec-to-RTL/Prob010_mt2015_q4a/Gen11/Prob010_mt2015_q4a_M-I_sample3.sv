module TopModule (
    input wire x,
    input wire y,
    output wire z
);

    // Direct continuous assignment implementing the boolean function
    assign z = (x ^ y) & x;

endmodule