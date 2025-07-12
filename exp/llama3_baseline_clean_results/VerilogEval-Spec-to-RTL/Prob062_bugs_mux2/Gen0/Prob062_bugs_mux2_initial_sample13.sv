module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out  // Declare out as an 8-bit vector
);

    assign out = (~sel & a) | (sel & b);

endmodule