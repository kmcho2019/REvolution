module AndGate (
    input  wire a,
    input  wire b,
    output wire y
);
    // Direct behavioral AND assignment for minimal delay and area
    assign y = a & b;
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