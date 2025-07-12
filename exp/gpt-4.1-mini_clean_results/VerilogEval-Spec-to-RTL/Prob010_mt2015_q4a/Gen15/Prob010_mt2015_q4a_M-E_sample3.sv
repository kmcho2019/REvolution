module TopModule (
    input  x,
    input  y,
    output z
);
    // Directly assign the output using built-in operators for minimal hierarchy and maximum synthesis optimization
    assign z = (x ^ y) & x;
endmodule