module TopModule (
    input in,
    output out
);
    // Optimal NOT gate implementation - synthesis will choose best inverter
    assign out = ~in;
endmodule