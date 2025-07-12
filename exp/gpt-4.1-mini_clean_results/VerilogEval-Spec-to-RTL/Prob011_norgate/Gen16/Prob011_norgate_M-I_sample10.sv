module TopModule (
    input  a,
    input  b,
    output out
);
    // Direct NOR gate implementation for minimal area, power, and delay
    assign out = ~(a | b);
endmodule