module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);
    // Directly slice the 4-bit segment indexed by sel
    assign out = in[sel * 4 +: 4];
endmodule