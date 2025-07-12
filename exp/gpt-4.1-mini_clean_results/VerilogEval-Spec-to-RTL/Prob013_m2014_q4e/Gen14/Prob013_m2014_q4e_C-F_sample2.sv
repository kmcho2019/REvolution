module NorGate (
    input wire a,
    input wire b,
    output wire y
);
    // Use built-in nor primitive internally for best PPA
    nor (y, a, b);
endmodule

module TopModule (
    input wire in1,
    input wire in2,
    output wire out
);
    // Instantiate the modular NorGate inside TopModule
    NorGate u_nor (
        .a(in1),
        .b(in2),
        .y(out)
    );
endmodule