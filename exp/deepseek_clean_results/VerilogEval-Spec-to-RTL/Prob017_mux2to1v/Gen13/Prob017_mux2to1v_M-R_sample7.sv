module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Directly assign each 20-bit segment of the output
    assign out[19:0]   = sel ? b[19:0]   : a[19:0];
    assign out[39:20]  = sel ? b[39:20]  : a[39:20];
    assign out[59:40]  = sel ? b[59:40]  : a[59:40];
    assign out[79:60]  = sel ? b[79:60]  : a[79:60];
    assign out[99:80]  = sel ? b[99:80]  : a[99:80];

endmodule