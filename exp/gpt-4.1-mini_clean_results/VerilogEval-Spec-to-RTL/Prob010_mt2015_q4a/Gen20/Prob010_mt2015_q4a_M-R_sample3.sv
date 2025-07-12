module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    // Direct combinational logic implementing z = (x^y) & x
    assign z = (x ^ y) & x;
endmodule