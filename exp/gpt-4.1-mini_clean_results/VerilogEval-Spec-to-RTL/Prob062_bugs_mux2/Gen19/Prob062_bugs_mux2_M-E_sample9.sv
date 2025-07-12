module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    input  [2:0] idx,  // bit index to select from inputs
    output       out
);

    wire bit_a = a[idx];
    wire bit_b = b[idx];

    assign out = sel ? bit_b : bit_a;

endmodule