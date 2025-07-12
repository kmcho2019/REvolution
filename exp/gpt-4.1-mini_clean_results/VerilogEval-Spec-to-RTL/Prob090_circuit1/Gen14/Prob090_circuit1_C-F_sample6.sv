module AndGate (
    input  wire a,
    input  wire b,
    output wire y
);
    // Minimal implementation using direct AND operator
    assign y = a & b;
endmodule

module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Instantiate the AndGate module to maintain modularity
    AndGate and_inst (
        .a(a),
        .b(b),
        .y(q)
    );
endmodule