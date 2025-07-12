module NorGate (
    input  a,
    input  b,
    output y
);
    // Directly implement the NOR logic to optimize delay, power, and area
    assign y = ~(a | b);
endmodule

module TopModule (
    input  in1,
    input  in2,
    output out
);
    // Instantiate NorGate for clear hierarchy and optimal performance
    NorGate u_nor (
        .a(in1),
        .b(in2),
        .y(out)
    );
endmodule