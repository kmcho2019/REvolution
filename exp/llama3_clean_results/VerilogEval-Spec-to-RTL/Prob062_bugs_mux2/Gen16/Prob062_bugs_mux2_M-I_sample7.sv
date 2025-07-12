module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Using a conditional operator for concise implementation
    assign out = (sel) ? b : a;

endmodule