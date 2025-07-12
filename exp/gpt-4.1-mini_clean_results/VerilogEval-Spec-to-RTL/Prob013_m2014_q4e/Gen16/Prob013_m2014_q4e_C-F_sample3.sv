module NorGate (
    input  wire a,
    input  wire b,
    output wire y
);
    // Direct NOR implementation for 2 inputs
    assign y = ~(a | b);
endmodule

module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    // Structural instantiation of NorGate for modular clarity and reusability
    NorGate u_nor (
        .a(in1),
        .b(in2),
        .y(out)
    );
endmodule