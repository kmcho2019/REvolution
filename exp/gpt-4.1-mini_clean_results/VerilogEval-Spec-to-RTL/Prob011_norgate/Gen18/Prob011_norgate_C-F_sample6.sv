module NORGate(
    input in1,
    input in2,
    output out
);
    assign out = ~(in1 | in2);
endmodule

module TopModule (
    input  a,
    input  b,
    output out
);
    NORGate nor_gate_inst (
        .in1(a),
        .in2(b),
        .out(out)
    );
endmodule