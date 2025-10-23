module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    assign out = sel ? b : a;  // 8-bit wide combinational mux

endmodule