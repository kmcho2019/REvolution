module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Direct ternary mux implementation - optimal for PPA
    assign out = sel ? b : a;

endmodule