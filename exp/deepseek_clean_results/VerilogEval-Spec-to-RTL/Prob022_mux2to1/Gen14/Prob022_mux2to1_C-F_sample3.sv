module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    // Optimal 2:1 mux implementation using ternary operator
    // Directly maps to hardware multiplexer primitives
    assign out = sel ? b : a;
endmodule