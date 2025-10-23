module XOR2 (
    input  a,
    input  b,
    output y
);
    assign y = a ^ b;
endmodule

module AND2 (
    input  a,
    input  b,
    output y
);
    assign y = a & b;
endmodule

module TopModule (
    input  x,
    input  y,
    output z
);
    wire xor_out;

    XOR2 xor_gate (
        .a(x),
        .b(y),
        .y(xor_out)
    );

    AND2 and_gate (
        .a(xor_out),
        .b(x),
        .y(z)
    );
endmodule