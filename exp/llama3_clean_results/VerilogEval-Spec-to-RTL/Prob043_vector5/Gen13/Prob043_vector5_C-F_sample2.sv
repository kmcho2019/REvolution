module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    // Define a small, reusable comparator function
    function automatic bit compare(bit x, bit y);
        compare = ~(x ^ y);
    endfunction

    // Directly assign the comparisons to the output bits
    assign out[24] = compare(a, a);
    assign out[23] = compare(a, b);
    assign out[22] = compare(a, c);
    assign out[21] = compare(a, d);
    assign out[20] = compare(a, e);

    assign out[19] = compare(b, a);
    assign out[18] = compare(b, b);
    assign out[17] = compare(b, c);
    assign out[16] = compare(b, d);
    assign out[15] = compare(b, e);

    assign out[14] = compare(c, a);
    assign out[13] = compare(c, b);
    assign out[12] = compare(c, c);
    assign out[11] = compare(c, d);
    assign out[10] = compare(c, e);

    assign out[9] = compare(d, a);
    assign out[8] = compare(d, b);
    assign out[7] = compare(d, c);
    assign out[6] = compare(d, d);
    assign out[5] = compare(d, e);

    assign out[4] = compare(e, a);
    assign out[3] = compare(e, b);
    assign out[2] = compare(e, c);
    assign out[1] = compare(e, d);
    assign out[0] = compare(e, e);

endmodule