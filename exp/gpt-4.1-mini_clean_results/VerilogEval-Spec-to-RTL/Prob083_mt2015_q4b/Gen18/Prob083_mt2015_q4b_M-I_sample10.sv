module TopModule(
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = ~(x ^ y);  // Equivalent to x XNOR y
endmodule