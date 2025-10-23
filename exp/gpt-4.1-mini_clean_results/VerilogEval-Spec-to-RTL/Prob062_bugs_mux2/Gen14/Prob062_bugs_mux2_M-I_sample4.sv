module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // 8-bit 2-to-1 mux using a ternary operator for efficient synthesis
    assign out = sel ? b : a;

endmodule