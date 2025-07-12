module TopModule (
    input  a,
    input  b,
    output out
);
    // Define internal NOT and AND gates as localparams for modularity illustration (not instantiated)
    // but implement the NOR function directly for minimal logic and optimal synthesis.

    // Direct NOR gate implementation for best PPA
    assign out = ~(a | b);

endmodule