module AndGate (
    input  wire a,
    input  wire b,
    output wire y
);
    wire na, nb;

    // Invert inputs using NOR logic
    assign na = ~(a | a);  // NOT a
    assign nb = ~(b | b);  // NOT b
    // AND is NOR of inverted inputs
    assign y = ~(na | nb);
endmodule

module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    AndGate and_inst (
        .a(a),
        .b(b),
        .y(q)
    );
endmodule