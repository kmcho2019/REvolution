module AndGate (
    input  wire a,
    input  wire b,
    output wire y
);
    // Behavioral AND gate for minimal logic, power, and delay
    assign y = a & b;
endmodule

module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Instantiate the reusable AndGate module for modularity and clarity
    AndGate and_inst (
        .a(a),
        .b(b),
        .y(q)
    );
endmodule