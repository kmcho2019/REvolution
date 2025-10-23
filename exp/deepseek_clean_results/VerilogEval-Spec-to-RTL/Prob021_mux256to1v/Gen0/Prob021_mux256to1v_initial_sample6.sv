module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Select the 4-bit output based on the sel value
    assign out = in[4*sel +: 4];

endmodule