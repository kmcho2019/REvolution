module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // The ternary operator directly and clearly implements the multiplexer's logic
    assign out = sel ? b : a;

endmodule