module Inverter (
    input  wire a,
    output wire y
);
    // Simple structural inverter
    assign y = ~a;
endmodule

module AndGate (
    input  wire a,
    input  wire b,
    output wire y
);
    // Simple structural AND gate
    assign y = a & b;
endmodule

module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    wire inv_in2;

    // Instantiate inverter for in2
    Inverter u_inv (
        .a(in2),
        .y(inv_in2)
    );

    // Instantiate AND gate with in1 and inverted in2
    AndGate u_and (
        .a(in1),
        .b(inv_in2),
        .y(out)
    );
endmodule