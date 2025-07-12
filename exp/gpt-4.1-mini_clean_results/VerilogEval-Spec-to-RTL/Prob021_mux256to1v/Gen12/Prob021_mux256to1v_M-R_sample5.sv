module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);
    // Select the 4-bit slice indexed by sel:
    // Each 4-bit word occupies bits [sel*4 +: 4]
    assign out = in[sel*4 +: 4];
endmodule