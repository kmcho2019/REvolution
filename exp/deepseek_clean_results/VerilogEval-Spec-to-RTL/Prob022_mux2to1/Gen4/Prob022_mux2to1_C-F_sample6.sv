module TopModule (
    input wire a,
    input wire b,
    input wire sel,
    output wire out
);
    // Optimal 2-to-1 mux implementation using ternary operator
    // Directly maps to single multiplexer primitive in hardware
    assign out = sel ? b : a;
endmodule