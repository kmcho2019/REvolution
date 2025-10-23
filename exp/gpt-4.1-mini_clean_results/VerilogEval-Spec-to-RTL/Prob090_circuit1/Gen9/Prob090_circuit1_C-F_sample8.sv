module AndGate (
    input  wire a,
    input  wire b,
    output wire y
);
    // Implement AND function directly for minimal logic and power
    assign y = a & b;
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