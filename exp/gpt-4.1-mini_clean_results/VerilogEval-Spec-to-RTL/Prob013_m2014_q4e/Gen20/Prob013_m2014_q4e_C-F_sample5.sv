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
    // Direct combinational NOR assignment for best PPA
    assign out = ~(in1 | in2);
endmodule