module TopModule (
    input  a, b, c, d, e,
    output [24:0] out
);
    // a comparisons
    assign out[24:20] = {1'b1, a~^b, a~^c, a~^d, a~^e};
    // b comparisons
    assign out[19:15] = {b~^a, 1'b1, b~^c, b~^d, b~^e};
    // c comparisons
    assign out[14:10] = {c~^a, c~^b, 1'b1, c~^d, c~^e};
    // d comparisons
    assign out[9:5]   = {d~^a, d~^b, d~^c, 1'b1, d~^e};
    // e comparisons
    assign out[4:0]   = {e~^a, e~^b, e~^c, e~^d, 1'b1};
endmodule