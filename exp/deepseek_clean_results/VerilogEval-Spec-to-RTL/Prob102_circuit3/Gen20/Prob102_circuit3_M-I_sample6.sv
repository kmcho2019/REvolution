module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Buffered inputs to reduce power consumption
    wire a_buf, b_buf, c_buf, d_buf;
    buf b1(a_buf, a);
    buf b2(b_buf, b);
    buf b3(c_buf, c);
    buf b4(d_buf, d);

    // Original optimal logic with buffered inputs
    assign q = (a_buf | b_buf) & (c_buf | d_buf);

endmodule