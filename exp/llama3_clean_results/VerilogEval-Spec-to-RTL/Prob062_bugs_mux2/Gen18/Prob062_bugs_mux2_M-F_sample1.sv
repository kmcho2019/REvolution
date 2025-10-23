module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out // Change output to 8-bit
);

    assign out = (~sel & a) | (sel & b); // Directly assign the 8-bit result to out

endmodule