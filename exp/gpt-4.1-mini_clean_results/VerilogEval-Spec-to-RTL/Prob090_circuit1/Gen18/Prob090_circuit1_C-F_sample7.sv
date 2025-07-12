module AndGate (
    input  wire a,
    input  wire b,
    output wire y
);
    // Direct behavioral assignment of AND operation for optimal PPA
    assign y = a & b;
endmodule

module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Instantiate AndGate module for modularity and clarity
    AndGate and_inst (
        .a(a),
        .b(b),
        .y(q)
    );
endmodule