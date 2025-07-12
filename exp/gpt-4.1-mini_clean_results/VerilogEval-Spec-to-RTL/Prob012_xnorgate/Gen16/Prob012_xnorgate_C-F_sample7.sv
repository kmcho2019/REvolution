module xnor_gate(
    input  a,
    input  b,
    output y
);
    assign y = ~(a ^ b);
endmodule

module TopModule(
    input  a,
    input  b,
    output out
);
    xnor_gate u_xnor (
        .a(a),
        .b(b),
        .y(out)
    );
endmodule