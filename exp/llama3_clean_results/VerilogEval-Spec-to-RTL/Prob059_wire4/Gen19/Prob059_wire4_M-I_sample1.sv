module TopModule(
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);
    wire w_int, x_int, y_int, z_int;
    assign w_int = a;
    assign x_int = b;
    assign y_int = b;
    assign z_int = c;
    assign w = w_int;
    assign x = x_int;
    assign y = y_int;
    assign z = z_int;
endmodule