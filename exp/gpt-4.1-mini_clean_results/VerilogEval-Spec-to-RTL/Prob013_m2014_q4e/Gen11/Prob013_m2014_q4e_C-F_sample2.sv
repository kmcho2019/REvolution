module OrGate (
    input  a,
    input  b,
    output y
);
    assign y = a | b;
endmodule

module NotGate (
    input  a,
    output y
);
    assign y = ~a;
endmodule

module TopModule (
    input  in1,
    input  in2,
    output out
);
    // Internal wires for gate outputs, can be used for extension or debugging
    wire or_wire;
    wire not_wire;

    // Generate block to instantiate gates structurally (prepared for expansion)
    generate
        OrGate u_or (
            .a(in1),
            .b(in2),
            .y(or_wire)
        );

        NotGate u_not (
            .a(or_wire),
            .y(not_wire)
        );
    endgenerate

    // Directly assign out from minimal NOR operation for optimal PPA
    assign out = ~(in1 | in2);

    // The internal gate outputs are available if needed without impacting out path
    // This keeps a clean modular hierarchy while output is minimal logic
endmodule