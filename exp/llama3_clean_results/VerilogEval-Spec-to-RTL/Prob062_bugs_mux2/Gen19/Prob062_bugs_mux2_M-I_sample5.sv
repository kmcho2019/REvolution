module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    assign out = sel ? b : a; // Use a conditional operator to select between 'a' and 'b'

endmodule