module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);

    // Directly index into 'in' with sel * 4 to select the 4-bit slice
    assign out = in[sel * 4 +: 4];

endmodule