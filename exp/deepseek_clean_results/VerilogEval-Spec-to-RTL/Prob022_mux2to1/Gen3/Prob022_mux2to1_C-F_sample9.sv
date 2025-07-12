module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    // Direct ternary implementation that synthesizes to optimal hardware mux
    assign out = sel ? b : a;
endmodule