module TopModule (
    input  a,    // Input A (selected when sel=0)
    input  b,    // Input B (selected when sel=1)
    input  sel,  // Selection signal
    output out   // Output (a when sel=0, b when sel=1)
);
    // Using ternary operator for optimal PPA
    // For power optimization in larger systems:
    // - Consider clock gating if sequential
    // - Add enable signal if mux isn't always needed
    assign out = sel ? b : a;
endmodule