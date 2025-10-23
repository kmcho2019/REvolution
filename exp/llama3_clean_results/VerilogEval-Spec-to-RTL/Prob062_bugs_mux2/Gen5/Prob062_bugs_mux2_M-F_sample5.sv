module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Direct implementation of a 2-to-1 multiplexer using the conditional operator
    assign out = sel ? b : a;

endmodule