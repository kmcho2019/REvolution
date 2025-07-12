module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);
    // Direct selection using concatenated indices for better PPA
    assign out = in[{sel, 2'b00} +: 4];
endmodule