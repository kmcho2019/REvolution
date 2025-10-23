module TopModule (
    input  a, b, c,
    output w, x, y, z
);
    // Alternative wire connection styles
    assign w = a, x = b;
    assign y = b, z = c;
endmodule