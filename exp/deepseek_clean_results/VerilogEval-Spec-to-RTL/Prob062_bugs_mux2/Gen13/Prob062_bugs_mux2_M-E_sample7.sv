module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Bitwise parallel selection implementation
    assign out[0] = sel ? a[0] : b[0];
    assign out[1] = sel ? a[1] : b[1];
    assign out[2] = sel ? a[2] : b[2];
    assign out[3] = sel ? a[3] : b[3];
    assign out[4] = sel ? a[4] : b[4];
    assign out[5] = sel ? a[5] : b[5];
    assign out[6] = sel ? a[6] : b[6];
    assign out[7] = sel ? a[7] : b[7];

endmodule