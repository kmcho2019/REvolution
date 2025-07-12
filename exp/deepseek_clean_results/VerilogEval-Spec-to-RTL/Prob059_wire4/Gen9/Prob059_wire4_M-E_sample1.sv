module TopModule (
    input a,
    input b,
    input c,
    output w,
    output x,
    output y,
    output z
);
    // Using buf gates to implement the wire connections
    buf b1(w, a);
    buf b2(x, b);
    buf b3(y, b);
    buf b4(z, c);
endmodule