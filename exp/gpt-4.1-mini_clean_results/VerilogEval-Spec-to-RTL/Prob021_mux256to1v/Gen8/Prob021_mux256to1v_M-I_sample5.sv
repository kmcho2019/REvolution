module TopModule(
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Directly select the 4-bit slice indexed by sel * 4
    assign out = in[sel*4 +: 4];

endmodule