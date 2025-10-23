module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Buffered inputs to reduce input capacitance effects
    wire a_buf, b_buf, c_buf, d_buf;
    buf(a_buf, a);
    buf(b_buf, b);
    buf(c_buf, c);
    buf(d_buf, d);

    // Original optimal logic implementation
    assign q = (a_buf | b_buf) & (c_buf | d_buf);

endmodule