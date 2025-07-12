module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    // Explicit AND-OR implementation that may guide synthesis to lower-power cells
    assign out = (~sel & a) | (sel & b);
endmodule