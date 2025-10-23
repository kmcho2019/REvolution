module TopModule (
    input  x,
    input  y,
    output wire z
);

    assign z = (x ^ y) & x;

endmodule