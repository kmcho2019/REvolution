module TopModule(
    input  a,
    input  b,
    output out
);
    // Basic gate modules defined locally for clarity and modularity
    // Small and simple, so synthesizer can optimize them well
    
    // AND gate module
    module and_gate(input x, input y, output z);
        assign z = x & y;
    endmodule

    // OR gate module
    module or_gate(input x, input y, output z);
        assign z = x | y;
    endmodule

    // NOT gate module
    module not_gate(input x, output z);
        assign z = ~x;
    endmodule

    // Internal wires for intermediate signals
    wire not_a, not_b;
    wire and_ab, and_notanotb;

    // Instantiate NOT gates for a and b
    not_gate u_not_a(.x(a), .z(not_a));
    not_gate u_not_b(.x(b), .z(not_b));

    // Instantiate AND gates for (a & b) and (~a & ~b)
    and_gate u_and_ab(.x(a), .y(b), .z(and_ab));
    and_gate u_and_notanotb(.x(not_a), .y(not_b), .z(and_notanotb));

    // OR gate to produce final output (a & b) | (~a & ~b)
    or_gate u_or(.x(and_ab), .y(and_notanotb), .z(out));

endmodule