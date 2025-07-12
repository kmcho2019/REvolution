module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    assign out = (sel) ? b : a;

    // Alternatively, for explicit bit-level control:
    // assign out = {8{(sel) ? b[7] : a[7], (sel) ? b[6] : a[6], (sel) ? b[5] : a[5], (sel) ? b[4] : a[4], (sel) ? b[3] : a[3], (sel) ? b[2] : a[2], (sel) ? b[1] : a[1], (sel) ? b[0] : a[0]}};
    // However, the first line provides the same functionality more concisely.

endmodule