module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    // Self-comparisons (always true)
    assign out[24] = 1'b1;  // a~^a
    assign out[18] = 1'b1;  // b~^b
    assign out[12] = 1'b1;  // c~^c
    assign out[6]  = 1'b1;  // d~^d
    assign out[0]  = 1'b1;  // e~^e

    // Cross comparisons (grouped by first operand)
    assign out[23:20] = {a~^b, a~^c, a~^d, a~^e};
    assign out[17:15] = {b~^c, b~^d, b~^e};
    assign out[11:10] = {c~^d, c~^e};
    assign out[5:4]   = {d~^e};
    
    // Symmetric comparisons
    assign out[19] = out[23];  // b~^a = a~^b
    assign out[16:14] = {out[22], out[21], out[20]};  // c~^a, d~^a, e~^a
    assign out[13:9] = {out[17], out[16], out[15], out[22], out[21]};  // c~^b, d~^b, e~^b, d~^c, e~^c
    assign out[8:1] = {out[16], out[15], out[21], out[11], out[10], out[5], out[4], out[10]};  // d~^a, e~^a, d~^b, e~^b, e~^c, e~^d, d~^e, e~^d

endmodule