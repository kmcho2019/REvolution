module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    assign out = (~sel & a) | (sel & b);

    // However, a better implementation considering the context would be:
    // assign out = (sel) ? b : a;

    // Or using a more explicit and bitwise approach that matches the original intention:
    assign out = ({8{~sel}} & a) | ({8{sel}} & b);

endmodule