module buf1 (input in, output out);
    assign out = in;
endmodule

module TopModule (
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);

    wire w_int, x_int, y_int, z_int;

    buf1 buf_w (.in(a), .out(w_int));
    buf1 buf_x (.in(b), .out(x_int));
    buf1 buf_y (.in(b), .out(y_int));
    buf1 buf_z (.in(c), .out(z_int));

    assign w = w_int;
    assign x = x_int;
    assign y = y_int;
    assign z = z_int;

endmodule