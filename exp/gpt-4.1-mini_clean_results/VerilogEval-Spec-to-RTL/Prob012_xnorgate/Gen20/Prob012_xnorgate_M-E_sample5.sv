module xor1 (
    input  wire a,
    input  wire b,
    output wire y
);
    // 1-bit XOR gate using built-in operator
    assign y = a ^ b;
endmodule

module inv1 (
    input  wire a,
    output wire y
);
    // 1-bit inverter
    assign y = ~a;
endmodule

module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    wire xor_out;

    // Instantiate the XOR gate
    xor1 u_xor (
        .a(a),
        .b(b),
        .y(xor_out)
    );

    // Instantiate the inverter to produce XNOR output
    inv1 u_inv (
        .a(xor_out),
        .y(out)
    );
endmodule