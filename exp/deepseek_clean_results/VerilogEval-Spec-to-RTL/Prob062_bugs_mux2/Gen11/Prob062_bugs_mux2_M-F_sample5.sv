module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Simple and clear 2-to-1 mux implementation
    assign out = sel ? b : a;

endmodule