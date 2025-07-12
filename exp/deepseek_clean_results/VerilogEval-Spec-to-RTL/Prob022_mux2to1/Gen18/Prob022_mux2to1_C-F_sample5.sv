module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    // Optimal fusion: ternary operator for readability + hardware efficiency
    assign out = sel ? b : a;
endmodule