module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Correct implementation of the 2-to-1 multiplexer logic
    assign out = (sel)? b : a;

    // Alternatively, to explicitly show the logic without relying on the conditional operator's behavior
    // assign out = (~sel & a) | (sel & b);

endmodule