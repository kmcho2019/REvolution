module NorGate (
    input  a,
    input  b,
    output y
);
    // Directly implement the NOR logic with a continuous assignment for minimal logic depth
    assign y = ~(a | b);
endmodule

module TopModule (
    input  in1,
    input  in2,
    output out
);
    // Instantiate the modular NorGate for clean hierarchy and reusability
    NorGate u_nor (
        .a(in1),
        .b(in2),
        .y(out)
    );
endmodule