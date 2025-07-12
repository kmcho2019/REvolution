module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Full 8-bit selection between a and b based on sel
    assign out = sel ? b : a;

endmodule