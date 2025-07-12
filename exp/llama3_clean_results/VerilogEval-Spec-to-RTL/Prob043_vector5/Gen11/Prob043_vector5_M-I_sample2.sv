module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    // Define a function for equality check
    function [0:0] equal(input [0:0] x, input [0:0] y);
        equal = ~(x ^ y);
    endfunction

    // Use the function for each comparison
    assign out[24] = equal(a, a);
    assign out[23] = equal(a, b);
    assign out[22] = equal(a, c);
    assign out[21] = equal(a, d);
    assign out[20] = equal(a, e);

    assign out[19] = equal(b, a);
    assign out[18] = equal(b, b);
    assign out[17] = equal(b, c);
    assign out[16] = equal(b, d);
    assign out[15] = equal(b, e);

    assign out[14] = equal(c, a);
    assign out[13] = equal(c, b);
    assign out[12] = equal(c, c);
    assign out[11] = equal(c, d);
    assign out[10] = equal(c, e);

    assign out[9] = equal(d, a);
    assign out[8] = equal(d, b);
    assign out[7] = equal(d, c);
    assign out[6] = equal(d, d);
    assign out[5] = equal(d, e);

    assign out[4] = equal(e, a);
    assign out[3] = equal(e, b);
    assign out[2] = equal(e, c);
    assign out[1] = equal(e, d);
    assign out[0] = equal(e, e);

endmodule