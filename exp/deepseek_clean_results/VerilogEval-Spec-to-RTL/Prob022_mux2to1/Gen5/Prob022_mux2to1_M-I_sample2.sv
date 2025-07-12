module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    // Pass-transistor implementation
    assign out = sel ? b : a;
endmodule