module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Correct implementation with proper width matching
    assign out = sel ? b : a;

endmodule