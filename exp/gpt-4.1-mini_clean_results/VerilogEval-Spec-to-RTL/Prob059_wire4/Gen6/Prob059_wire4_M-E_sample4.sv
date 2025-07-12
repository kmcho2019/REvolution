module Buffer (
    input  in,
    output out
);
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

    Buffer buf_w (.in(a), .out(w));
    Buffer buf_x (.in(b), .out(x));
    Buffer buf_y (.in(b), .out(y));
    Buffer buf_z (.in(c), .out(z));

endmodule