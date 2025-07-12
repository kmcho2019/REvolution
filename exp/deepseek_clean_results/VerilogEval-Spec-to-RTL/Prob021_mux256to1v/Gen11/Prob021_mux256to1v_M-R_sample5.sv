module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Directly select 4 bits from input based on sel value
    assign out = in[(sel * 4) +: 4];

endmodule