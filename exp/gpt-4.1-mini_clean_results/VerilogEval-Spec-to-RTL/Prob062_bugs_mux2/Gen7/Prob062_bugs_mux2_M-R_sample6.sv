module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Output entire selected vector based on sel
    assign out = sel ? b : a;

endmodule