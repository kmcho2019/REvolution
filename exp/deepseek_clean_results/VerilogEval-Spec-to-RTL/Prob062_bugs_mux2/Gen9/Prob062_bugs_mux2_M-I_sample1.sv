module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Direct mux implementation using conditional operator
    assign out = sel ? b : a;

endmodule