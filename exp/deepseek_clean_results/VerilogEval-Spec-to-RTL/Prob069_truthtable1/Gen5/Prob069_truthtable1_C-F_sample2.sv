module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // Optimal implementation using minimized Boolean expression:
    // f = 1 when (x3=0 AND x2=1) OR (x3=1 AND x1=1)
    assign f = (~x3 & x2) | (x3 & x1);
    // synthesis keep // Optional: Hint for synthesis tool to preserve this logic
endmodule