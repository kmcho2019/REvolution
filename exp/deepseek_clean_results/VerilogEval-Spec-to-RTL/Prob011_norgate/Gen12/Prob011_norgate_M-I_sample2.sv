module TopModule (
    input a,
    input b,
    output out
);
    // Using explicit technology cell instantiation if available
    NOR2X1 nor_cell (.A(a), .B(b), .Y(out));
endmodule