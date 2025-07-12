module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Optimal 8-bit 2-to-1 mux with clear selection logic
    assign out = sel ? a : b;

endmodule