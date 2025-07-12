module xor_gate(
    input  a,
    input  b,
    output y
);
    assign y = a ^ b;
endmodule

module not_gate(
    input  in,
    output out
);
    assign out = ~in;
endmodule

module TopModule(
    input  a,
    input  b,
    output out
);
    wire xor_out;
    
    xor_gate u_xor (
        .a(a),
        .b(b),
        .y(xor_out)
    );
    
    not_gate u_not (
        .in(xor_out),
        .out(out)
    );
endmodule