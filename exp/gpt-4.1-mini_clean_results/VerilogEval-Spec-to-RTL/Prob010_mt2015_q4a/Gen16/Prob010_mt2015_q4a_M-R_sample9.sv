module TopModule (
    input  x,
    input  y,
    output z
);
    // Directly assign the boolean function
    assign z = (x ^ y) & x;
endmodule