module OrGate (
    input  wire a,
    input  wire b,
    output wire y
);
    assign y = a | b;
endmodule

module NotGate (
    input  wire a,
    output wire y
);
    assign y = ~a;
endmodule

module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    // Direct single-level NOR gate instantiation for optimal PPA
    assign out = ~(in1 | in2);
endmodule