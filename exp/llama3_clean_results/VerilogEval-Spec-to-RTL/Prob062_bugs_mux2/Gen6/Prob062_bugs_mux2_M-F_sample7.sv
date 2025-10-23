module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Direct implementation of a 2-to-1 multiplexer using the conditional operator
    // This implementation correctly selects between 'a' and 'b' based on 'sel'
    assign out = sel ? b : a;

endmodule