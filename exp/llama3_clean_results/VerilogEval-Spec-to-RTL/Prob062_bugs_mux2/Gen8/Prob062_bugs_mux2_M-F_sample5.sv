module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // For each bit position in the output vector, select from 'a' if 'sel' is 0, and from 'b' if 'sel' is 1.
    // This can be achieved using the ternary operator for each bit position, ensuring the output is correctly vectorized.
    assign out = (sel) ? b : a;

    // Alternatively, to explicitly show the selection process for each bit:
    // assign out[7] = (sel) ? b[7] : a[7];
    // assign out[6] = (sel) ? b[6] : a[6];
    // assign out[5] = (sel) ? b[5] : a[5];
    // assign out[4] = (sel) ? b[4] : a[4];
    // assign out[3] = (sel) ? b[3] : a[3];
    // assign out[2] = (sel) ? b[2] : a[2];
    // assign out[1] = (sel) ? b[1] : a[1];
    // assign out[0] = (sel) ? b[0] : a[0];

endmodule