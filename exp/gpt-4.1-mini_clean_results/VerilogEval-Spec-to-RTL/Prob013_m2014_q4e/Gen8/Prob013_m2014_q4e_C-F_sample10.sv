module OrGate (
    input  a,
    input  b,
    output y
);
    assign y = a | b;
endmodule

module NotGate (
    input  a,
    output y
);
    assign y = ~a;
endmodule

module TopModule (
    input  in1,
    input  in2,
    output out
);
    // Directly implement 2-input NOR with minimal logic and no internal wires
    assign out = ~(in1 | in2);
endmodule