module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Using shift operation (sel << 2) instead of multiplication (sel*4)
    // This is equivalent to multiplying by 4 but more efficient in hardware
    assign out = in[(sel << 2) +: 4];

endmodule