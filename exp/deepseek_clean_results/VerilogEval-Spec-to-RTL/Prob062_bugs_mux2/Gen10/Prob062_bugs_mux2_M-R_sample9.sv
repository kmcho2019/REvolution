module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Simplified 8-bit 2-to-1 mux using ternary operator
    assign out = sel ? b : a;

endmodule