module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    assign out = (~sel & {8{1'b1}} & a) | (sel & {8{1'b1}} & b);

    // Alternatively, a simpler implementation would be:
    // assign out = (sel) ? b : a;

endmodule