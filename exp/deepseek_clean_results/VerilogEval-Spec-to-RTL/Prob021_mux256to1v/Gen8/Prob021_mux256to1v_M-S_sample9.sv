module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Directly compute starting position using shifts:
    // sel * 4 = (sel << 2)
    assign out = in[sel << 2 +: 4];

endmodule