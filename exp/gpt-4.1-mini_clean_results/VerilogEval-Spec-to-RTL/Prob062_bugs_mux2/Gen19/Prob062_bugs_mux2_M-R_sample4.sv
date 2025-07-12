module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Use explicit 8-bit masks for sel and ~sel, then AND with inputs and OR the results
    assign out = ({8{~sel}} & a) | ({8{sel}} & b);

endmodule