module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out // Change output to 8 bits
);

    assign out = (~sel) ? a : b; // Use conditional operator for clarity and correctness

endmodule