module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    // Optimal 2:1 mux implementation using ternary operator
    // Maps directly to hardware multiplexer primitive
    assign out = sel ? b : a;
endmodule