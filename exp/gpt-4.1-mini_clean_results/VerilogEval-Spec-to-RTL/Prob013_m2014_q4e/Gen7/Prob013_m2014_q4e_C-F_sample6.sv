module NorGate (
    input a,
    input b,
    output y
);
    // Internally use the built-in nor primitive for best PPA
    nor (y, a, b);
endmodule

module TopModule (
    input in1,
    input in2,
    output out
);
    // Instantiate the custom modular NOR gate
    NorGate u_nor (
        .a(in1),
        .b(in2),
        .y(out)
    );
endmodule