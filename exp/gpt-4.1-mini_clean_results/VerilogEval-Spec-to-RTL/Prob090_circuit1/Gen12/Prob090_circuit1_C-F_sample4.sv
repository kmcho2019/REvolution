module AndGate (
    input  wire a,
    input  wire b,
    output wire y
);
    // Implement AND function using a single gate primitive for best PPA
    and (y, a, b);
endmodule

module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Instantiate the modular AndGate
    AndGate and_inst (
        .a(a),
        .b(b),
        .y(q)
    );
endmodule