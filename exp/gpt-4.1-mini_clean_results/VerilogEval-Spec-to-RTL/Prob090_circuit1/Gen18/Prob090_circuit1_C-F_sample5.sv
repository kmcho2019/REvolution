module AndGate (
    input  wire a,
    input  wire b,
    output wire y
);
    // Behavioral AND gate for optimal power, area, and performance
    assign y = a & b;
endmodule

module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Instantiate AndGate for modular and reusable design
    AndGate and_inst (
        .a(a),
        .b(b),
        .y(q)
    );
endmodule